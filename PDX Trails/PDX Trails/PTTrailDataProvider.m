//
//  PTTrailDataProvider.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailDataProvider.h"
#import "PTTrail.h"
#import "PTTrailSegment.h"
#import "PTPLATSTrailImportOperation.h"
#import "PTConstants.h"

@interface PTTrailDataProvider()

@property (strong, nonatomic) NSOperationQueue *operationQueue;

- (void)beginAsyncImport;

@end

@implementation PTTrailDataProvider

+ (instancetype)sharedDataProvider;
{
    static id dataProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataProvider = [[self alloc] init];
    });
    
    return dataProvider;
}

- (NSArray *)trailsForRegion:(MKCoordinateRegion)region;
{
    CLLocationCoordinate2D coords[3];
    
    coords[0] = CLLocationCoordinate2DMake(45.517892, -122.670287);
    coords[1] = CLLocationCoordinate2DMake(45.517106, -122.671848);
    coords[2] = CLLocationCoordinate2DMake(45.511847, -122.674679);
    
    PTTrailSegment *segment = [[PTTrailSegment alloc] initWithCoordinates:coords count:3];
    PTTrail *trail = [PTTrail new];
    
    trail.name = @"West Side Test Trail";
    trail.identifier = @"1";
    trail.description = @"TEST DATA";
    trail.segments = @[segment];
    
    
    
    coords[0] = CLLocationCoordinate2DMake(45.51263, -122.668134);
    coords[1] = CLLocationCoordinate2DMake(45.512406, -122.668055);
    coords[2] = CLLocationCoordinate2DMake(45.507983, -122.666163);
    
    
    PTTrail *trail2 = [PTTrail new];
    PTTrailSegment *segment2 = [[PTTrailSegment alloc] initWithCoordinates:coords count:3];

    trail2.name = @"East Side Test Trail";
    trail2.identifier = @"1";
    trail2.description = @"TEST DATA";
    trail2.segments = @[segment2];

    
    [self beginAsyncImport];

    
    return @[trail, trail2];
}

#pragma mark PTTrailDataProvider Private

- (void)beginAsyncImport;
{
    PTPLATSTrailImportOperation *import = [[PTPLATSTrailImportOperation alloc] init];
    __block PTPLATSTrailImportOperation *weakImport = import;
    
    import.completionBlock = ^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PTDataImportOperationFinishedNotification object:weakImport.importedTrails];
        }];
    };
    
    [self.operationQueue addOperation:import];
}

#pragma mark NSObject

- (instancetype)init;
{
    if ( self = [super init] ) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

@end
