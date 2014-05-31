//
//  PTRootMapViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTRootMapViewController.h"

#define METERS_PER_MILE 1609.344

@interface PTRootMapViewController ()

@property (strong, nonatomic) MKMapView *mapView;

- (IBAction)zoomToCurrentLocation:(id)sender;
- (IBAction)zoomToPortland:(id)sender;

@end

@implementation PTRootMapViewController

#pragma mark PTRootMapViewController

- (IBAction)zoomToCurrentLocation:(id)sender;
{

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
    
    [self.view addSubview:self.mapView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _mapView );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:nil views:views]];
    
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
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

@end
