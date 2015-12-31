//
//  MSEvent.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSEvent.h"

@implementation MSEvent

- (instancetype)initWithStart {
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _durationInHours = 0.0;
        _title = @"";
        _location = @"";
        _information = @"";
    }
    return self;
}

+ (instancetype)create {
    return [[self alloc] initWithStart];
}

@end
