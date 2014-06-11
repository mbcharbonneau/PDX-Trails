//
//  PTTrailInfoViewController.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import UIKit;
@import MapKit;

@class PTTrail;

@interface PTTrailInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

- (instancetype)initWithTrail:(PTTrail *)trail;

@end
