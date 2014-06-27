//
//  PTRLISImporter.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/27/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTRLISImporter.h"

@interface PTRLISImporter()

@property (strong, nonatomic) NSMutableDictionary *trails;

@end

@implementation PTRLISImporter

- (void)main;
{
    @autoreleasepool {
        
        self.trails = [NSMutableDictionary new];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"rlis" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *featureCollection = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        for ( NSDictionary *feature in featureCollection[@"features"] ) {
            
            NSDictionary *properties = feature[@"properties"];
            NSDictionary *geometry = feature[@"geometry"];
     //       NSString *segmentID = feature[@"id"];
            NSString *segmentID = properties[@"RLIS:trailid"];
            NSString *trailID = properties[@"RLIS:systemname"];
            
            if ( [segmentID isKindOfClass:[NSNumber class]] )
                segmentID = [(NSNumber *)segmentID stringValue];
            
            if ( trailID == nil )
                trailID = properties[@"name"];
            
            if ( trailID == nil )
                trailID = segmentID;
            
            if ( ![geometry[@"type"] isEqualToString:@"LineString"] )
                continue;
            
            NSArray *coordinateArrays = geometry[@"coordinates"];
            NSUInteger index, count = [coordinateArrays count];
            CLLocationCoordinate2D coordinates[count];

            for ( index = 0; index < count; index++ ) {
                NSArray *pair = coordinateArrays[index];
                double longitude = [pair[0] doubleValue];
                double latitude = [pair[1] doubleValue];
                coordinates[index] = CLLocationCoordinate2DMake( latitude, longitude );
            }

            OTTrailSegment *segment = [[OTTrailSegment alloc] initWithIdentifier:segmentID coordinates:coordinates count:count];
            NSMutableArray *segmentsArray = self.trails[trailID];
            
            if ( segmentsArray == nil ) {
                segmentsArray = [NSMutableArray new];
                self.trails[trailID] = segmentsArray;
            }
            
            [segmentsArray addObject:segment];
            segment.openStreetMapTags = properties;
            segment.name = properties[@"name"];
        }
        
        self.importedTrails = [NSMutableArray new];
        
        [self.trails enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            OTTrail *trail = [[OTTrail alloc] initWithIdentifier:key];
            trail.segments = [obj copy];
            trail.name = [[[trail.segments firstObject] openStreetMapTags] objectForKey:@"RLIS:systemname"];
            
            [self.importedTrails addObject:trail];
        }];
    }
}


//
//
//
//
//self.stage = OTImportStageParsingSegments;
//
//NSString *path = [self.filePaths objectForKey:OTTrailSegmentsFilePathKey]; // required file.
//
//@try {
//    
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *featureCollection = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//    
//    for ( NSDictionary *feature in featureCollection[@"features"] ) {
//        
//        NSDictionary *properties = feature[@"properties"];
//        NSDictionary *geometry = feature[@"geometry"];
//        NSString *identifier = properties[@"id"];
//        NSArray *coordinateArrays = geometry[@"coordinates"];
//        
//        if ( [identifier length] == 0 || [coordinateArrays count] == 0 )
//            continue;
//        
//        NSUInteger index, count = [coordinateArrays count];
//        CLLocationCoordinate2D coordinates[count];
//        
//        for ( index = 0; index < count; index++ ) {
//            NSArray *pair = coordinateArrays[index];
//            double longitude = [pair[0] doubleValue];
//            double latitude = [pair[1] doubleValue];
//            coordinates[index] = CLLocationCoordinate2DMake( latitude, longitude );
//        }
//        
//        OTTrailSegment *segment = [[OTTrailSegment alloc] initWithIdentifier:identifier coordinates:coordinates count:count];
//        
//        segment.name = properties[@"name"];
//        segment.steward = self.stewardsByIDs[properties[@"steward_id"]];
//        segment.openStreetMapTags = [self splitOSMTagsString:properties[@"osm_tags"]];
//        segment.motorVehiclePolicy = OTTrailPolicyFromString( properties[@"motor_vehicles"] );
//        segment.footTrafficPolicy = OTTrailPolicyFromString( properties[@"foot"] );
//        segment.bicyclePolicy = OTTrailPolicyFromString( properties[@"bicycle"] );
//        segment.horsePolicy = OTTrailPolicyFromString( properties[@"horse"] );
//        segment.skiPolicy = OTTrailPolicyFromString( properties[@"ski"] );
//        segment.wheelchairPolicy = OTTrailPolicyFromString( properties[@"wheelchair"] );
//        
//        self.segmentsByIDs[identifier] = segment;
//    }
//}
//@catch (NSException *exception) {
//    
//    NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString( @"OpenTrails importer could not parse %@.", @"" ), path];
//    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDescription };
//    self.error = [[NSError alloc] initWithDomain:OTErrorDomain code:OTErrorCodeDataFormatError userInfo:userInfo];
//    self.stage = OTImportStageParsingFinished;
//    return;
//}
//
//[self beginNextTask];


@end
