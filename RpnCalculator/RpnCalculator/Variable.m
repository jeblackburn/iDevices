//
//  Variable.m
//  RpnCalculator
//
//  Created by Jon Blackburn on 2/11/12.
//  Copyright (c) 2012 DRW Holdings, LLC. All rights reserved.
//

#import "Variable.h"

@implementation Variable

@synthesize key = _key;

- (id)initWithKey:(NSObject *)keyy {
    self = [super init];
    if (self) {
        self.key = keyy;
    }
    return self;
}

- (NSString *)description {
    return self.key.description;
}

@end
