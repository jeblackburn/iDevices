//
//  Variable.h
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/11/12.
//  Copyright (c) 2012 DRW Holdings, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Variable : NSObject

@property (nonatomic, strong) NSObject *key;

- (id)initWithKey:(NSObject *)key;

@end
