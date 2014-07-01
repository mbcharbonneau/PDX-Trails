//
//  OTTrailSegment.m
//  OpenTrails Importer
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Marc Charbonneau
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "OTTrailSegment.h"

OTTrailPolicy OTTrailPolicyFromString(NSString *aString) {
    
    OTTrailPolicy policy;
    
    if ( [aString isEqualToString:@"yes"] ) {
        policy = OTTrailPolicyAllowed;
    } else if ( [aString isEqualToString:@"no"] ) {
        policy = OTTrailPolicyNotAllowed;
    } else if ( [aString isEqualToString:@"permissive"] ) {
        policy = OTTrailPolicyDesignated;
    } else if ( [aString isEqualToString:@"designated"] ) {
        policy = OTTrailPolicyDesignated;
    } else {
        policy = OTTrailPolicyUnknown;
    }
    
    return policy;
}

@interface OTTrailSegment()

- (CLLocationCoordinate2D)coordinateAtIndex:(NSUInteger)idx;

@end

@implementation OTTrailSegment

#pragma mark OTTrailSegment

- (instancetype)initWithIdentifier:(NSString *)identifier coordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count;
{
    NSParameterAssert( [identifier length] > 0 );
    NSParameterAssert( count > 0 );
    
    if ( self = [super init] ) {
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
        NSInteger index;
        
        for ( index = 0; index < count; index++ ) {
            CLLocationCoordinate2D coordinate = coordinates[index];
            [array addObject:[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)]];
        }
        
        _identifier = identifier;
        _coordinates = [array copy];
    }
    
    return self;
}

- (double)distance;
{
    double meters = 0.0;
    NSUInteger idx;
    
    for ( idx = 0; idx < [self.coordinates count] - 1; idx++ ) {
        
        CLLocationCoordinate2D first = [self coordinateAtIndex:idx];
        CLLocationCoordinate2D second = [self coordinateAtIndex:idx + 1];
        CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:first.latitude longitude:first.longitude];
        CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:second.latitude longitude:second.longitude];
        
        meters += [firstLocation distanceFromLocation:secondLocation];
    }
    
    return meters;
}

- (CLLocationCoordinate2D)midpoint;
{
    if ( [self.coordinates count] == 1 )
        return [self coordinateAtIndex:0];
    
    double halfDistance = [self distance] / 2.0;
    double walkDistance = 0.0;
    NSUInteger idx;
    
    for ( idx = 0; idx < [self.coordinates count] - 1; idx++ ) {
        
        CLLocationCoordinate2D first = [self coordinateAtIndex:idx];
        CLLocationCoordinate2D second = [self coordinateAtIndex:idx + 1];
        CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:first.latitude longitude:first.longitude];
        CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:second.latitude longitude:second.longitude];

        double lineDistance = [firstLocation distanceFromLocation:secondLocation];
        walkDistance += lineDistance;
        
        if ( walkDistance > halfDistance ) {
            
            double lon1 = first.longitude * M_PI / 180;
            double lon2 = second.longitude * M_PI / 180;
            
            double lat1 = first.latitude * M_PI / 180;
            double lat2 = second.latitude * M_PI / 180;
            
            double dLon = lon2 - lon1;
            
            double x = cos(lat2) * cos(dLon);
            double y = cos(lat2) * sin(dLon);
            
            double lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) );
            double lon3 = lon1 + atan2(y, cos(lat1) + x);
            
            return CLLocationCoordinate2DMake( lat3 * 180 / M_PI, lon3 * 180 / M_PI );
        }
    }
    
    return kCLLocationCoordinate2DInvalid;
}

#pragma mark OTTrailSegment Private

- (CLLocationCoordinate2D)coordinateAtIndex:(NSUInteger)idx;
{
    CLLocationCoordinate2D coordinate;
    [self.coordinates[idx] getValue:&coordinate];
    return coordinate;
}

#pragma mark NSObject

- (NSString *)description;
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<%@: %p, name=%@, coordinates=", NSStringFromClass( [self class] ), self, self.name];
    
    NSInteger idx, count = [self.coordinates count];
    
    for ( idx = 0; idx < count; idx++ ) {
        CLLocationCoordinate2D coordinate = [self coordinateAtIndex:idx];
        [string appendFormat:@"%f %f, ", coordinate.latitude, coordinate.longitude];
    }
    
    [string appendString:@">"];
    return string;
}

@end
