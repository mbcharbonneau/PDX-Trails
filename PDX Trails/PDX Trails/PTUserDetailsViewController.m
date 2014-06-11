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
#import "PTTrailFinderViewControllerProtocol.h"
#import "PTCyclingTrailFinderViewController.h"
#import "PTWalkingTrailFinderViewController.h"
#import "PTADATrailFinderViewController.h"
#import "PTHikingTrailFinderViewController.h"

@interface PTUserDetailsViewController ()

@property (strong, nonatomic) UIScrollView *modeSelectionScrollView;
@property (strong, nonatomic) UIViewController<PTTrailFinderViewControllerProtocol> *childViewController;
@property (strong, nonatomic) NSMutableArray *childViewConstraints;

- (IBAction)chooseMode:(id)sender;

@end

@implementation PTUserDetailsViewController

#pragma mark PTUserDetailsViewController

- (IBAction)chooseMode:(id)sender;
{
    if ( self.childViewController != nil ) {
        
        [self.view removeConstraints:self.childViewConstraints];
        [self.childViewConstraints removeAllObjects];
        [self.childViewController.view removeFromSuperview];
        [self.childViewController removeFromParentViewController];
    }
    
    PTUserMode mode = [sender selectedSegmentIndex];
    
    switch ( mode ) {
        case PTUserModeCycling:
            self.childViewController = [[PTCyclingTrailFinderViewController alloc] init];
            break;
        case PTUserModeAccessible:
            self.childViewController = [[PTADATrailFinderViewController alloc] init];
            break;
        case PTUserModeHiking:
            self.childViewController = [[PTHikingTrailFinderViewController alloc] init];
            break;
        default:
            self.childViewController = [[PTWalkingTrailFinderViewController alloc] init];
            break;
    }
    
    self.childViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:self.childViewController];
    [self.view addSubview:self.childViewController.view];
    
    SWRevealViewController *revealController = self.revealViewController;
    UIView *childView = self.childViewController.view;
    NSDictionary *views = NSDictionaryOfVariableBindings( childView );
    NSDictionary *metrics = @{ @"margin_left" : @( revealController.rightViewRevealOverdraw ), @"margin_top" : @(186.0f) };
    
    [self.childViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin_left)-[childView]|" options:0 metrics:metrics views:views]];
    [self.childViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin_top)-[childView]|" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:self.childViewConstraints];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.modeSelectionScrollView = [UIScrollView new];
    self.modeSelectionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modeSelectionScrollView.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *items = @[PTNameForMode( PTUserModeHiking ), PTNameForMode( PTUserModeWalking ), PTNameForMode( PTUserModeCycling ), PTNameForMode( PTUserModeAccessible ), PTNameForMode( PTUserModeRunning )];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor PTBlueTintColor];
    [segmentedControl setDividerImage:nil forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl addTarget:self action:@selector(chooseMode:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *helpLabel = [UILabel new];
    helpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    helpLabel.text = NSLocalizedString( @"Tell us a little about yourself, and we'll show you trails in your neighborhood.", @"" );
    helpLabel.numberOfLines = 2;
    helpLabel.textAlignment = NSTextAlignmentCenter;
    helpLabel.font = [UIFont systemFontOfSize:20.0f];
    helpLabel.textColor = [UIColor grayColor];
    
    [self.modeSelectionScrollView addSubview:segmentedControl];
    [self.view addSubview:self.modeSelectionScrollView];
    [self.view addSubview:helpLabel];
    
    SWRevealViewController *revealController = self.revealViewController;
    CGFloat margin = revealController.rightViewRevealOverdraw;
    NSDictionary *views = NSDictionaryOfVariableBindings( _modeSelectionScrollView, segmentedControl, helpLabel );
    NSDictionary *metrics = @{ @"margin_left" : @( margin ), @"padding_left" : @( margin + 20.0f ), @"padding_right" : @( 20.0f ), @"height" : @(100.0f), @"width" : @( [items count] * 100.0f ) };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segmentedControl(width)]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segmentedControl(height)]-(20)-[helpLabel]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding_left)-[helpLabel]-(padding_right)-|" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin_left)-[_modeSelectionScrollView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_modeSelectionScrollView(height)]" options:0 metrics:metrics views:views]];
    
    [self chooseMode:segmentedControl];
}

#pragma mark NSObject

- (instancetype)init;
{
    if ( self = [super initWithNibName:nil bundle:nil] ) {
        
        _childViewConstraints = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
