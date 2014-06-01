//
//  PTUserDetailsViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTUserDetailsViewController.h"
#import "PTConstants.h"
#import "SWRevealViewController.h"

@interface PTUserDetailsViewController ()

@property (strong, nonatomic) UIScrollView *modeSelectionScrollView;

@end

@implementation PTUserDetailsViewController

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.modeSelectionScrollView = [UIScrollView new];
    self.modeSelectionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *items = @[PTNameForMode( PTUserModeWalking ), PTNameForMode( PTUserModeHiking ), PTNameForMode( PTUserModeCycling ), PTNameForMode( PTUserModeAccessible ), PTNameForMode( PTUserModeRunning )];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.selectedSegmentIndex = 0;
    
    [self.modeSelectionScrollView addSubview:segmentedControl];
    [self.view addSubview:self.modeSelectionScrollView];
    
    SWRevealViewController *revealController = self.revealViewController;
    NSDictionary *views = NSDictionaryOfVariableBindings( _modeSelectionScrollView, segmentedControl );
    NSDictionary *metrics = @{ @"margin" : @( revealController.rightViewRevealOverdraw ), @"height" : @(100.0f), @"width" : @( [items count] * 100.0f ) };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segmentedControl(width)]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segmentedControl(height)]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_modeSelectionScrollView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_modeSelectionScrollView(height)]" options:0 metrics:metrics views:views]];
}

#pragma mark NSObject

- (instancetype)init;
{
    return [self initWithNibName:nil bundle:nil];
}

@end
