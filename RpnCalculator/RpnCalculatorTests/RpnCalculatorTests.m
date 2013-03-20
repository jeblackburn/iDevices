//
//  RpnCalculatorTests.m
//  RpnCalculatorTests
//
//  Created by Jon Blackburn on 9/21/12.
//
//

#import "RpnCalculatorTests.h"
#import "CalculatorBrain.h"

@implementation RpnCalculatorTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testOperationWithTwoOperands {
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:[NSNumber numberWithDouble:2.5]];
    [brain pushOperand:[NSNumber numberWithDouble:2]];
    double result = [brain performOperation:@"*"];
    STAssertEqualsWithAccuracy(5.0, result, 0.00001, @"Multiply didn't work");
}

- (void)testDivideWithTwoOperands {
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:[NSNumber numberWithDouble:7]];
    [brain pushOperand:[NSNumber numberWithDouble:2]];
    double result = [brain performOperation:@"/"];
    STAssertEqualsWithAccuracy(3.5, result, 0.00001, @"Divide didn't work");
}

- (void)testGetDescriptionWithTwoOperands {
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:[NSNumber numberWithDouble:2.5]];
    [brain pushOperand:[NSNumber numberWithDouble:2]];
    [brain performOperation:@"*"];
    id program = brain.program;
    NSString *desc = [CalculatorBrain descriptionOfProgram:program];
    STAssertEqualObjects(@"2.5 * 2", desc, @"Description is broken");
}

- (void) testDescriptionForNestedOperation {
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:[NSNumber numberWithDouble:2.5]];
    [brain pushOperand:[NSNumber numberWithDouble:2]];
    [brain performOperation:@"*"];
    [brain pushOperand: [NSNumber numberWithDouble:4]];
    [brain performOperation:@"/"];
    NSString *desc = [CalculatorBrain descriptionOfProgram:brain.program];
    STAssertEqualObjects(@"2.5 * 2 / 4", desc, @"Description is broken");
}

- (void) testDescriptionForNestedOperationRequiringParens {
    CalculatorBrain *brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:[NSNumber numberWithDouble:2.5]];
    [brain pushOperand:[NSNumber numberWithDouble:2]];
    [brain performOperation:@"+"];
    [brain pushOperand: [NSNumber numberWithDouble:4]];
    [brain performOperation:@"/"];
    NSString *desc = [CalculatorBrain descriptionOfProgram:brain.program];
    STAssertEqualObjects(@"(2.5 + 2) / 4", desc, @"Description is broken");
}


@end
