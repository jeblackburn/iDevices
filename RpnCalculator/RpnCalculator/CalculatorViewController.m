//
//  CalculatorViewController.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "Variable.h"
#include <math.h>

@interface CalculatorViewController()
@property (nonatomic) bool userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSNumberFormatter *decimalFormatChecker;
- (void) refreshHistory;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize description = _description;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize decimalFormatChecker = _formatter;

- (NSNumberFormatter *) decimalFormatChecker {
    if (! _formatter) _formatter =[[NSNumberFormatter alloc] init];
    return _formatter;
}

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init ];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        if ([digit isEqualToString:@"0"]) return; // "00" is no good
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = true;
    }
}

- (IBAction)clearButtonPressed {
    [self.brain clear];
    self.display.text = @"0";
    [self refreshHistory];
    self.userIsInTheMiddleOfEnteringANumber = false;
}

- (IBAction)variableButtonPressed:(UIButton *)sender {
    NSString *key = sender.currentTitle;
    Variable *variable = [[Variable alloc] initWithKey:key];
    [self.brain pushOperand:variable];
    [self refreshHistory];
}

- (IBAction)backButtonPressed:(id)sender {
    if (self.display.text.length > 0) {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        if (self.display.text.length == 0) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = false;
        } else {
            self.userIsInTheMiddleOfEnteringANumber = true;
        }
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
    self.userIsInTheMiddleOfEnteringANumber = false;
    [self refreshHistory];
}

- (IBAction)decimalPointPressed:(UIButton *)sender {
    NSString *possibleNewValue = [self.display.text stringByAppendingString:sender.currentTitle];
    if ([self.decimalFormatChecker numberFromString:possibleNewValue]) {
        self.display.text = possibleNewValue;
        self.userIsInTheMiddleOfEnteringANumber = true;
    }
}

- (IBAction)testOneButtonPressed:(UIButton *)sender {
//    [self.brain ]
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString * resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    [self refreshHistory];
    self.description.text = [CalculatorBrain descriptionOfProgram:(self.brain.program)];
}

- (IBAction)posNegButtonPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber || [self.display.text doubleValue] == 0) {
        NSRange found = [self.display.text rangeOfString:@"-"];
        if (found.location == NSNotFound) {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        } else {
            self.display.text = [self.display.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
    } else {
        [self operationPressed:sender];
    }
}

- (void) refreshHistory {
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)viewDidUnload {
    [self setDescription:nil];
    [super viewDidUnload];
}
@end
