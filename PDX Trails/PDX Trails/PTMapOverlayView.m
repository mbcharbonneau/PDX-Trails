//
//  PTMapOverlayView.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/26/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTMapOverlayView.h"
#import "PTConstants.h"

@interface  PTMapOverlayView()
@end

@implementation PTMapOverlayView

- (id)initWithFrame:(CGRect)frame;
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.5f;
        self.userInteractionEnabled = NO;
        
        _noTrailsLabel = [UILabel new];
        _noTrailsLabel.font = [UIFont PTAppFontOfSize:32.0f];
        _noTrailsLabel.text = NSLocalizedString( @"No Trails in this Region", @"" );
        _noTrailsLabel.textColor = [UIColor lightGrayColor];
        _noTrailsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noTrailsLabel.textAlignment = NSTextAlignmentCenter;
        _noTrailsLabel.hidden = YES;
        
        _zoomButton = [UIButton new];
        _zoomButton.translatesAutoresizingMaskIntoConstraints = NO;
        _zoomButton.hidden = _noTrailsLabel.hidden;
        [_zoomButton setTitleColor:[UIColor PTBlueTintColor] forState:UIControlStateNormal];
        [_zoomButton setTitle:NSLocalizedString( @"Go to Portland", @"" ) forState:UIControlStateNormal];

        [self addSubview:_noTrailsLabel];
        [self addSubview:_zoomButton];
        
        NSDictionary *views = NSDictionaryOfVariableBindings( _noTrailsLabel, _zoomButton );
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_noTrailsLabel]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_zoomButton]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_noTrailsLabel][_zoomButton(44)]" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_noTrailsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
{
    return [self.zoomButton pointInside:[self convertPoint:point toView:self.zoomButton] withEvent:event];
}

- (BOOL)showsNoTrailsMessage;
{
    return !self.noTrailsLabel.hidden;
}

- (void)setShowsNoTrailsMessage:(BOOL)showsNoTrailsMessage;
{
    [UIView animateWithDuration:0.25 animations:^{
        self.userInteractionEnabled = showsNoTrailsMessage;
        self.noTrailsLabel.hidden = !self.userInteractionEnabled;
        self.zoomButton.hidden = !self.userInteractionEnabled;
        self.alpha = showsNoTrailsMessage ? 0.9f : 0.5f;
    }];
}

@end
