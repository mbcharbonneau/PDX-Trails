//
//  PTRootMapViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTRootMapViewController.h"
#import "SWRevealViewController.h"

#define METERS_PER_MILE 1609.344
#define ADDRESS_OVERLAY_ALPHA 0.4f

@interface PTRootMapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIView *addressOverlayView;
@property (strong, nonatomic) UIButton *currentLocationButton;

- (IBAction)zoomToCurrentLocation:(id)sender;
- (IBAction)zoomToPortland:(id)sender;

@end

@implementation PTRootMapViewController

#pragma mark PTRootMapViewController

- (IBAction)zoomToCurrentLocation:(id)sender;
{
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
    
- (IBAction)zoomToPortland:(id)sender;
{
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake( 45.5424364, -122.654422 );
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance( zoomLocation, 3.0 * METERS_PER_MILE, 3.0 * METERS_PER_MILE );
    
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.mapView = [MKMapView new];
    self.mapView.delegate = self;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.addressOverlayView = [UIView new];
    self.addressOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressOverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.addressOverlayView.alpha = ADDRESS_OVERLAY_ALPHA;
    
    UITextField *textField = [UITextField new];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.delegate = self;
    textField.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
    textField.layer.cornerRadius = 4.0f;
    textField.textColor = [UIColor whiteColor];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIButton *button = [UIButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentLocationButton = [UIButton new];
    self.currentLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentLocationButton.backgroundColor = [UIColor redColor];
    [self.currentLocationButton addTarget:self action:@selector(zoomToCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.addressOverlayView];
    [self.view addSubview:self.currentLocationButton];
    [self.addressOverlayView addSubview:textField];
    [self.addressOverlayView addSubview:button];

    NSDictionary *views = NSDictionaryOfVariableBindings( _mapView, _addressOverlayView, textField, button, _currentLocationButton );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addressOverlayView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addressOverlayView(84.0)]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_currentLocationButton(44.0)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_currentLocationButton(44.0)]-(20)-|" options:0 metrics:nil views:views]];

    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-160.0-[textField]-96.0-[button(44.0)]-20.0-|" options:0 metrics:nil views:views]];
    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[textField(44.0)]" options:0 metrics:nil views:views]];
    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[button(44.0)]" options:0 metrics:nil views:views]];
    
    [self zoomToPortland:nil];
}

#pragma mark NSObject

- (instancetype)init;
{
    return [self initWithNibName:nil bundle:nil];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance( userLocation.location.coordinate, 3.0 * METERS_PER_MILE, 3.0 * METERS_PER_MILE );
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    self.addressOverlayView.alpha = 1.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    self.addressOverlayView.alpha = ADDRESS_OVERLAY_ALPHA;
}

@end
