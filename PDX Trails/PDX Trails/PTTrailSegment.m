//
//  PTTrailSegment.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailSegment.h"

@implementation PTTrailSegment

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

@end
