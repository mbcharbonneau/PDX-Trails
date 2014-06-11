//
//  PTPLATSTrailImportOperation.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface PTPLATSImportOperation : NSOperation

@property (strong) NSArray *importedTrails;
@property (strong) NSError *error;

@end