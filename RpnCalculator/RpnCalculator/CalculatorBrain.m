//
//  CalculatorBrain.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray*) operandStack {
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand{
    NSNumber *last = [self.operandStack lastObject];
    if (last) [self.operandStack removeLastObject];
    return [last doubleValue];
}

- (void)clear {
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation {

    double result = 0;
    if ([@"*" isEqual:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([@"+" isEqual:operation]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"/" isEqual:operation]) {
        double right = [self popOperand];
        double left = [self popOperand];
        result = left / right;
    } else if ([@"-" isEqual:operation]) {
        double right = [self popOperand];
        double left = [self popOperand];
        result = left - right;
    } else if ([@"sin" isEqual:operation]) {
        result = sin([self popOperand]);
    } else if ([@"cos" isEqual:operation]) {
        result = cos([self popOperand]);
    } else if ([@"sqrt" isEqual:operation]) {
        result = sqrt([self popOperand]);
    } else if ([@"pi" isEqual:operation]) {
        double coefficient = 1;
        if (self.operandStack.lastObject) coefficient = [self popOperand];
        result = M_PI * coefficient;
    }
    [self pushOperand:result];
    return result;
}


@end
