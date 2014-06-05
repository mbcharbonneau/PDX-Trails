//
//  PTTrailSegment.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailSegment.h"

@implementation PTTrailSegment

#pragma mark PTTrailSegment

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count;
{
    if ( self = [super init] ) {
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
        NSInteger index;
        
        for ( index = 0; index < count; index++ ) {
            CLLocationCoordinate2D coordinate = coordinates[index];
            [array addObject:[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)]];
        }
        
        _coordinates = [array copy];
    }
    
    return self;
}

#pragma mark NSObject

- (NSString *)description;
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<%@: %p, coordinates=", NSStringFromClass( [self class] ), self];
    
    NSInteger index, count = [self.coordinates count];
    
    for ( index = 0; index < count; index++ ) {
        CLLocationCoordinate2D coordinate;
        [self.coordinates[index] getValue:&coordinate];
        [string appendFormat:@"%f %f, ", coordinate.latitude, coordinate.longitude];
    }
    
    [string appendString:@">"];
    return string;
}

@end
