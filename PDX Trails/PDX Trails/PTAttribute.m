//
//  PTAttribute.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTAttribute.h"

#define MILES_TO_METERS 1609.34

@interface PTAttribute()

- (NSPredicate *)distancePredicate;

@end

@implementation PTAttribute

#pragma mark PTAttribute

- (instancetype)initWithDictionary:(NSDictionary *)attributeData;
{
    NSParameterAssert( attributeData != nil );
    
    if ( self = [super init] ) {
        
        self.key = attributeData[@"key"];
        self.prompt = attributeData[@"prompt"];
        self.answers = attributeData[@"answers"];
        self.selectedAnswer = 0;
    }
    
    return self;
}

- (NSPredicate *)trailPredicate;
{
    if ( [self.key isEqualToString:@"distance"] )
        return self.distancePredicate;
    
    return nil;
}

#pragma mark PTAttribute Private

- (NSPredicate *)distancePredicate;
{
    double min = 0.0, max = 0.0;
    
    switch ( self.selectedAnswer ) {
        case 0:
            min = 0.0;
            max = 2.0;
            break;
        case 1:
            min = 2.0;
            max = 5.0;
            break;
        case 2:
            min = 5.0;
            max = 10.0;
            break;
        case 3:
            min = 10.0;
            max = 99999.0;
            break;
    }
    
    min = min * MILES_TO_METERS;
    max = max * MILES_TO_METERS;
    
    return [NSPredicate predicateWithFormat:@"distance >= %f && distance <= %f", min, max];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object;
{
    if ( object == self )
        return YES;
    
    if ( object == nil || ![object isKindOfClass:[PTAttribute class]] )
        return NO;
    
    return [self.key isEqualToString:[object key]];
}

- (NSUInteger)hash;
{
    return [self.key hash];
}

@end
