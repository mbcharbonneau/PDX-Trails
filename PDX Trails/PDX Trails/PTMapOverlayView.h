//
//  PTMapOverlayView.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/26/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTMapOverlayView : UIView

@property (assign, nonatomic) BOOL showsNoTrailsMessage;
@property (strong, nonatomic) UILabel *noTrailsLabel;
@property (strong, nonatomic) UIButton *zoomButton;

@end
