//
//  PTTrailInfoViewController.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import UIKit;
@import MapKit;

@class OTTrail;

@interface PTTrailInfoViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithTrail:(OTTrail *)trail;

@end
