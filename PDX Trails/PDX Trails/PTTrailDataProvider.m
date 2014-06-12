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
#import "PTPLATSImportOperation.h"
#import "PTConstants.h"

@interface PTTrailDataProvider()

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableArray *trails;

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
    return self.trails;
}

- (NSArray *)filterQuestionsForMode:(PTUserMode)mode;
{
    NSURL *questionsURL = [[NSBundle mainBundle] URLForResource:@"Filters" withExtension:@"plist"];
    NSArray *questions = [NSArray arrayWithContentsOfURL:questionsURL];
    
    return questions;
}

#pragma mark PTTrailDataProvider Private

- (void)beginAsyncImport;
{
    PTPLATSImportOperation *import = [[PTPLATSImportOperation alloc] init];
    __block PTPLATSImportOperation *weakImport = import;
    
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
        _trails = [[NSMutableArray alloc] init];
        
        [self beginAsyncImport];
    }
    
    return self;
}

@end
