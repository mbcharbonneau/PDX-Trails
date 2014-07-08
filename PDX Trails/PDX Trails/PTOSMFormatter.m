//
//  PTOSMFormatter.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/30/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTOSMFormatter.h"

@interface PTOSMFormatter()
@end

@implementation PTOSMFormatter

- (NSString *)stringForTags:(NSDictionary *)OSMTags;
{
    return [self stringForObjectValue:OSMTags];
}

- (NSString *)stringForObjectValue:(id)obj;
{
    NSMutableString *string = [NSMutableString new];
    NSDictionary *dictionary = obj;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [string appendFormat:@"%@ == %@, ", key, obj];
    }];
    
    return string;
}

@end
