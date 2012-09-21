//
//  CalculatorBrain.h
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

- (void)pushOperand:(id)operand;
- (double)performOperation:(NSString *)operation;
- (void)setVariable:(NSString *)name toValue:(double)value;
- (void) clear;

@end
