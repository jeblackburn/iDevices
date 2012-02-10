//
//  CalculatorViewController.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorViewController()
@property (nonatomic) bool userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSNumberFormatter *formatter;
-(void)appendToHistory:(NSString *)value;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize formatter = _formatter;

- (NSNumberFormatter *) formatter {
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
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = true;
    }
}
- (IBAction)clearButtonPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.history.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = false;
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
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = false;
    [self appendToHistory:self.display.text];
    [self appendToHistory:@" "];
}

- (IBAction)decimalPointPressed:(UIButton *)sender {
    NSString *possibleNewValue = [self.display.text stringByAppendingString:sender.currentTitle];
    if ([self.formatter numberFromString:possibleNewValue]) {
        self.display.text = possibleNewValue;
        self.userIsInTheMiddleOfEnteringANumber = true;
        [self appendToHistory:sender.currentTitle];
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self appendToHistory:sender.currentTitle];
    [self appendToHistory:@" "];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString * resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (void)appendToHistory:(NSString *)value {
    self.history.text = [self.history.text stringByAppendingString:value];
}

@end
