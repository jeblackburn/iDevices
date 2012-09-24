//
//  Operand.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 9/23/12.
//
//

#import "Operation.h"
#include <math.h>

@implementation OperationUtil
+ (double)popOperandOffStack:(NSMutableArray *) stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        return [topOfStack doubleValue];
    } else if ([topOfStack conformsToProtocol:@protocol(Operation)]) {
        NSObject <Operation> *operation = topOfStack;
        return [operation operate:stack];
    }
    return result;
}

+ (NSString *)popDescriptionOffStack:(NSMutableArray *) stack {
    NSString *result = nil;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack description];
    } else if ([topOfStack conformsToProtocol:@protocol(Operation)]) {
        NSString *fmt = [topOfStack needsParentheses] ? @"(%@)" : @"%@";
        result = [NSString stringWithFormat:fmt, [topOfStack description:stack]];
    }
    return result;
}

@end

@implementation Multiply
- (double) operate:(NSMutableArray *) stack {
    double second = [OperationUtil popOperandOffStack:stack];
    double first = [OperationUtil popOperandOffStack:stack];
    NSLog(@"%@: %g, %g", [[self class] description], first, second);
    return first * second;
}
- (NSString *) description:(NSMutableArray *)stack {
    NSString *second = [OperationUtil popDescriptionOffStack:stack];
    NSString *first = [OperationUtil popDescriptionOffStack:stack];
    return [NSString stringWithFormat:@"%@ * %@", first, second];
}
- (BOOL) needsParentheses {return false;}
@end

@implementation Divide
- (double) operate:(NSMutableArray *) stack {
    double second = [OperationUtil popOperandOffStack:stack];
    double first = [OperationUtil popOperandOffStack:stack];
    NSLog(@"%@: %g, %g", [[self class] description], first, second);
    return first / second;
}
- (NSString *) description:(NSMutableArray *)stack {
    NSString *second = [OperationUtil popDescriptionOffStack:stack];
    NSString *first = [OperationUtil popDescriptionOffStack:stack];
    return [NSString stringWithFormat:@"%@ / %@", first, second];
}
- (BOOL) needsParentheses {return false;}
@end

@implementation Add
- (double) operate:(NSMutableArray *) stack {
    double second = [OperationUtil popOperandOffStack:stack];
    double first = [OperationUtil popOperandOffStack:stack];
    NSLog(@"%@: %g, %g", [[self class] description], first, second);
    return first + second;
}
- (NSString *) description:(NSMutableArray *)stack {
    NSString *second = [OperationUtil popDescriptionOffStack:stack];
    NSString *first = [OperationUtil popDescriptionOffStack:stack];
    return [NSString stringWithFormat:@"%@ + %@", first, second];
}
- (BOOL) needsParentheses {return true;}
@end

@implementation Subtract
- (double) operate:(NSMutableArray *) stack {
    double second = [OperationUtil popOperandOffStack:stack];
    double first = [OperationUtil popOperandOffStack:stack];
    NSLog(@"%@: %g, %g", [[self class] description], first, second);
    return first - second;
}
- (NSString *) description:(NSMutableArray *)stack {
    NSString *second = [OperationUtil popDescriptionOffStack:stack];
    NSString *first = [OperationUtil popDescriptionOffStack:stack];
    return [NSString stringWithFormat:@"%@ - %@", first, second];
}
- (BOOL) needsParentheses {return true;}
@end

@implementation Sine
- (double) operate:(NSMutableArray *) stack {
    return sin([OperationUtil popOperandOffStack:stack]);
}
- (NSString *) description:(NSMutableArray *)stack {
    return [NSString stringWithFormat:@"sin(%@)", [OperationUtil popDescriptionOffStack:stack]];
}
- (BOOL) needsParentheses {return false;}
@end

@implementation Cos
- (double) operate:(NSMutableArray *) stack {
    return cos([OperationUtil popOperandOffStack:stack]);
}
- (NSString *) description:(NSMutableArray *)stack {
    return [NSString stringWithFormat:@"cos(%@)", [OperationUtil popDescriptionOffStack:stack]];
}
- (BOOL) needsParentheses {return false;}
@end

@implementation Sqrt
- (double) operate:(NSMutableArray *) stack {
    return sqrt([OperationUtil popOperandOffStack:stack]);
}
- (NSString *) description:(NSMutableArray *)stack {
    return [NSString stringWithFormat:@"sqrt(%@)", [OperationUtil popDescriptionOffStack:stack]];
}
- (BOOL) needsParentheses {return false;}
@end

@implementation Pi
- (double) operate:(NSMutableArray *) stack {
    double coeff = 1;
    if ([stack lastObject]) coeff = [OperationUtil popOperandOffStack:stack];
    return M_PI * coeff;
}
- (NSString *) description:(NSMutableArray *)stack {
    if ([stack lastObject]) {
        return [NSString stringWithFormat:@"PI * %@", [OperationUtil popDescriptionOffStack:stack]];
    } else return @"PI";
}
- (BOOL) needsParentheses {return false;}
@end

@implementation Inverse
- (double) operate:(NSMutableArray *) stack {
    return -1 * [OperationUtil popOperandOffStack:stack];
}
- (NSString *) description:(NSMutableArray *)stack {
    return [NSString stringWithFormat:@"-1 * %@", [OperationUtil popDescriptionOffStack:stack]];
}
- (BOOL) needsParentheses {return false;}
@end

