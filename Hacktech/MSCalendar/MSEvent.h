//
//  MSEvent.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEvent : NSObject


@property NSDate *start;
@property double durationInHours;
@property NSString *title;
@property NSString *location;
@property NSString *information;

- (instancetype)initWithStart;
+ (instancetype)create;

@end



