//
//  PTRLISImporter.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/27/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import Foundation;
@import MapKit;
#import "OTOpenTrails.h"

@interface PTRLISImporter : NSOperation

@property (strong, nonatomic) NSMutableArray *importedTrails;

@end
