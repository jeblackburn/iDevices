//
//  CalculatorBrain.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import "Variable.h"
#import "Operation.h"
#include <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong, readonly) NSDictionary *variablesMap;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

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
    return [OperationUtil popOperandOffStack:stack];
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
        if ([nextItem conformsToProtocol:@protocol(Operation)]) {
            description = [description stringByAppendingFormat:@"%@", [nextItem description:stack]];
        } else {
            description = [description stringByAppendingFormat:@"%@ ", nextItem];
        }
    }
    return description;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSString *result = @"hrmmm...";
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableArray *stack = [program mutableCopy];
        result = [self appendStackItemToOutputString:stack];
    }
    return result;
}


+ (id <Operation>) fromString:(NSString *) opName {
    
    if ([@"*" isEqual:opName])      return [[Multiply alloc] init];
    if ([@"/" isEqual:opName])      return [[Divide alloc] init];
    if ([@"+" isEqual:opName])      return [[Add alloc] init];
    if ([@"-" isEqual:opName])      return [[Subtract alloc] init];
    if ([@"sin" isEqual:opName])    return [[Sine alloc] init];
    if ([@"cos" isEqual:opName])    return [[Cos alloc] init];
    if ([@"sqrt" isEqual:opName])   return [[Sqrt alloc] init];
    if ([@"π" isEqual:opName])      return [[Pi alloc] init];
    if ([@"+/-" isEqual:opName])    return [[Inverse alloc] init];
    @throw [NSException exceptionWithName:@"Unrecognized operation name" reason:[NSString stringWithFormat:@"Invalid operation name %@", opName] userInfo:nil];

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
    if ([operand isKindOfClass:[NSString class]])
    {
        NSString *op = operand;
        id operation = [CalculatorBrain fromString:op];
        [self.operandStack addObject:operation];
        
    }
    [self.operandStack addObject:operand];
}

- (void)clear {
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation {
    id op = [CalculatorBrain fromString:operation];
    [self.programStack addObject:op];
    return [CalculatorBrain runProgram:self.program];
}

@end
