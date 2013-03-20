//
//  Operation.h
//  RpnCalculator
//
//  Created by Jon Blackburn on 9/23/12.
//
//

#import <Foundation/Foundation.h>

@interface OperationUtil
+ (double)popOperandOffStack:(NSMutableArray *) stack;
@end

@protocol Operation
- (double) operate:(NSMutableArray *) stack;
- (NSString *) description:(NSMutableArray *) stack;
@end

@interface OperationBase : NSObject <Operation>
@end

@interface Multiply : NSObject <Operation>
@end

@interface Divide : NSObject <Operation>
@end

@interface Subtract : NSObject <Operation>
@end

@interface Add : NSObject <Operation>
@end

@interface Sine : NSObject <Operation>
@end

@interface Cos : NSObject <Operation>
@end

@interface Sqrt : NSObject <Operation>
@end

@interface Pi : NSObject <Operation>
@end

@interface Inverse : NSObject <Operation>
@end

