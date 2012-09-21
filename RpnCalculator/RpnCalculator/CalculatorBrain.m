//
//  CalculatorBrain.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import "Variable.h"
#include <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong, readonly) NSDictionary *variablesMap;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

+ (double)popOperandOffStack:(NSMutableArray *) stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        return [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([@"*" isEqual:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"+" isEqual:operation]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"/" isEqual:operation]) {
            double right = [self popOperandOffStack:stack];
            double left = [self popOperandOffStack:stack];
            result = left / right;
        } else if ([@"-" isEqual:operation]) {
            double right = [self popOperandOffStack:stack];
            double left = [self popOperandOffStack:stack];
            result = left - right;
        } else if ([@"sin" isEqual:operation]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([@"cos" isEqual:operation]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([@"sqrt" isEqual:operation]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([@"π" isEqual:operation]) {
            double coefficient = 1;
            if ([stack lastObject]) coefficient = [self popOperandOffStack:stack];
            result = M_PI * coefficient;
        } else if ([@"+/-" isEqual:operation]) {
            result = -1 * [self popOperandOffStack:stack];
        }
    } 
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        NSArray *stack = program;
        for (id element in stack) {
            if ([element isKindOfClass:[Variable class]]) {
                [variables addObject:element];
            }
        }
    }
    if (variables.count == 0) return nil;
    return variables;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    for (int x = 0; x < stack.count; x++) {
        id obj = [stack objectAtIndex:x];
        if ([obj isKindOfClass:[Variable class]]) {
            Variable *v = obj;
            [stack replaceObjectAtIndex:x withObject:[variableValues objectForKey:v.key]];
        }
    }
    return [self runProgram:stack];
}

+ (NSString *)appendStackItemToOutputString:(NSMutableArray *)stack {
    NSString *description = @"";
    id nextItem = [stack lastObject];
    if (nextItem) {
        [stack removeLastObject];
        description = [self appendStackItemToOutputString:stack];
        description = [description stringByAppendingFormat:@"%@ ", nextItem];
    }
    return description;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSString *result = @"";
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableArray *stack = [program mutableCopy];
        result = [self appendStackItemToOutputString:stack];
    }
    return result;
}

- (void)setVariable:(NSString *)name toValue:(double)value {
    [self.variablesMap setValue:[NSNumber numberWithDouble:value] forKey:name];
}

- (id) program {
    return [self.programStack copy];
}

- (NSDictionary *) variablesMap {
    return [self.variablesMap copy];
}

- (NSMutableArray*) operandStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(id)operand {
    [self.operandStack addObject:operand];
}

- (void)clear {
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

@end
