//
//  PTTrailDataProvider.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailDataProvider.h"
#import "PTConstants.h"
#import "PTAttribute.h"
#import "OTImportOperation.h"

#import "PTRLISImporter.h"

#define MIN_SUITABILITY 0.2f

@interface PTTrailDataProvider()

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableSet *trails;
@property (strong, nonatomic) NSMutableSet *answers;

- (void)beginAsyncImport;

@end

@implementation PTTrailDataProvider

#pragma mark PTTrailDataProvider

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
    return [self.trails allObjects];
}

- (NSArray *)filterQuestionsForMode:(PTUserMode)mode;
{
    NSString *filename = nil;
    
    switch ( mode ) {
        case PTUserModeHiking:
            filename = @"HikingFilters";
            break;
        case PTUserModeCycling:
            filename = @"CyclingFilters";
            break;
        case PTUserModeWalking:
            filename = @"WalkingFilters";
            break;
        case PTUserModeAccessible:
            filename = @"AccessibilityFilters";
            break;
        default:
            break;
    }
    
    NSURL *questionsURL = [[NSBundle mainBundle] URLForResource:filename withExtension:@"plist"];
    NSArray *questions = [NSArray arrayWithContentsOfURL:questionsURL];
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:[questions count]];
    
    for ( NSDictionary *data in questions )
        [attributes addObject:[[PTAttribute alloc] initWithDictionary:data]];
        
    return attributes;
}

- (CGFloat)suitabilityOfTrail:(OTTrail *)trail;
{
    if ( [self.answers count] == 0 )
        return 1.0;
    
    CGFloat result = 0.0f;
    
    for ( PTAttribute *attribute in self.answers ) {
        
        if ( [attribute.trailPredicate evaluateWithObject:trail] )
            result += 1.0f;
    }
    
    return MAX( MIN_SUITABILITY, result / [self.answers count] );
}

- (void)userSelectedAnswer:(PTAttribute *)attribute;
{
    [self.answers addObject:attribute];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PTTrailSelectionChangedNotification object:attribute];
}

#pragma mark PTTrailDataProvider Private

- (void)beginAsyncImport;
{
//    NSString *areas = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"geojson"];
//    NSString *trails = [[NSBundle mainBundle] pathForResource:@"named_trails" ofType:@"csv"];
//    NSString *stewards = [[NSBundle mainBundle] pathForResource:@"stewards" ofType:@"csv"];
//    NSString *segments = [[NSBundle mainBundle] pathForResource:@"trail_segments" ofType:@"geojson"];
//    NSString *trailheads = [[NSBundle mainBundle] pathForResource:@"trailheads" ofType:@"geojson"];
//    
//    NSDictionary *filePaths = @{ OTTrailSegmentsFilePathKey : segments,
//                                 OTNamedTrailsFilePathKey : trails,
//                                 OTTrailheadsFilePathKey : trailheads,
//                                 OTAreasFilePathKey : areas,
//                                 OTStewardsFilePathKey : stewards };
//
//    OTImportOperation *import = [[OTImportOperation alloc] initWithFilePaths:filePaths];
//    __block __typeof(import) weakImport = import;
//    
//    import.completionBlock = ^{
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.trails addObjectsFromArray:weakImport.importedTrails];
//            [[NSNotificationCenter defaultCenter] postNotificationName:PTDataImportOperationFinishedNotification object:self];
//        }];
//    };
    
    PTRLISImporter *import = [[PTRLISImporter alloc] init];
    __block __typeof(import) weakImport = import;
    
    import.completionBlock = ^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.trails addObjectsFromArray:weakImport.importedTrails];
            [[NSNotificationCenter defaultCenter] postNotificationName:PTDataImportOperationFinishedNotification object:self];
        }];
    };

    
    [self.operationQueue addOperation:import];
}

#pragma mark NSObject

- (instancetype)init;
{
    if ( self = [super init] ) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _answers = [[NSMutableSet alloc] init];
        _trails = [[NSMutableSet alloc] init];
        
        [self beginAsyncImport];
    }
    
    return self;
}

@end
