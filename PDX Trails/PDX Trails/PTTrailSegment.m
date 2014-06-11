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

- (UIBezierPath *)mapPath;
{
    NSInteger index, count = [self.coordinates count];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for ( index = 0; index < count; index++ ) {
        CLLocationCoordinate2D coordinate;
        [self.coordinates[index] getValue:&coordinate];
        MKMapPoint point = MKMapPointForCoordinate( coordinate );
        
        if ( [path isEmpty] )
            [path moveToPoint:CGPointMake( point.x, point.y )];
        else
            [path addLineToPoint:CGPointMake( point.x, point.y )];
    }
    
    return path;
}

#pragma mark NSObject

- (NSString *)description;
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<%@: %p, name=%@, coordinates=", NSStringFromClass( [self class] ), self, self.name];
    
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
