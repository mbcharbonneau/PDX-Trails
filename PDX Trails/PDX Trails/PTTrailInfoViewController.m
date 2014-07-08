//
//  PTTrailInfoViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailInfoViewController.h"
#import "PTConstants.h"
#import "OTOpenTrails.h"
#import "PTTrailRenderer.h"
#import "PTTrailOverlay.h"
#import "PTOSMFormatter.h"

#define DEFAULT_SEGMENT_NAME NSLocalizedString( @"Trailway", @"" );

@interface PTTrailInfoViewController ()

@property (strong, nonatomic) OTTrail *trail;
@property (strong, nonatomic) OTTrailSegment *selectedSegment;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UITapGestureRecognizer *backgroundTapRecognizer;
@property (strong, nonatomic) UIPickerView *segmentSelectionView;
@property (strong, nonatomic) UIButton *trailInfoTabButton;
@property (strong, nonatomic) UIButton *segmentsTabButton;

- (void)backgroundTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation PTTrailInfoViewController

#pragma mark PTTrailInfoViewController

-(instancetype)initWithTrail:(OTTrail *)trail;
{
    NSParameterAssert( trail != nil );
    
    if ( self = [super initWithNibName:nil bundle:nil] ) {
        _trail = trail;
    }
    
    return self;
}

#pragma mark PTTrailInfoViewController Private

- (void)backgroundTap:(UITapGestureRecognizer *)recognizer;
{
    if ( recognizer.state != UIGestureRecognizerStateEnded )
        return;
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)setSelectedSegment:(OTTrailSegment *)selectedSegment;
{
    if ( _selectedSegment == selectedSegment )
        return;
    
    BOOL isShowingAnnotation = [self.mapView.annotations count] != 0;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = [selectedSegment midpoint];
    annotation.title = selectedSegment.name ?: DEFAULT_SEGMENT_NAME;
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:!isShowingAnnotation];
    
    PTOSMFormatter *formatter = [PTOSMFormatter new];
    self.infoLabel.text = [formatter stringForTags:[selectedSegment openStreetMapTags]];
    
    _selectedSegment = selectedSegment;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.trail.name;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont PTAppFontOfSize:24.0f];
    
    self.infoLabel = [UILabel new];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel.font = [UIFont PTAppFontOfSize:14.0f];
    self.infoLabel.numberOfLines = 0;
    
    self.segmentSelectionView = [UIPickerView new];
    self.segmentSelectionView.dataSource = self;
    self.segmentSelectionView.delegate = self;
    self.segmentSelectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmentSelectionView.backgroundColor = [UIColor lightGrayColor];
    
    self.mapView = [MKMapView new];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.scrollEnabled = NO;
    
    PTTrailOverlay *overlay = [[PTTrailOverlay alloc] initWithTrail:self.trail];
    MKMapRect mapRect = overlay.boundingMapRect;
    mapRect = MKMapRectInset( mapRect, MKMapRectGetWidth( mapRect ) * -0.1, MKMapRectGetHeight( mapRect ) * -0.1 );
    
    [self.mapView addOverlay:overlay];
    [self.mapView setRegion:MKCoordinateRegionForMapRect( mapRect ) animated:YES];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.segmentSelectionView];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.infoLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings( titleLabel, _segmentSelectionView, _mapView, _infoLabel );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView(350)]-(20)-[titleLabel][_segmentSelectionView][_infoLabel]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[titleLabel]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_infoLabel]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[_segmentSelectionView]-(40)-|" options:0 metrics:nil views:views]];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    self.backgroundTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    self.backgroundTapRecognizer.cancelsTouchesInView = NO;
    
    [self.view.window addGestureRecognizer:self.backgroundTapRecognizer];
    self.selectedSegment = [self.trail.segments firstObject];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake( 0.0f, 0.0f, 500.0f, 748.0f );
}

#pragma mark NSObject

- (void)dealloc;
{
    [self.backgroundTapRecognizer.view removeGestureRecognizer:self.backgroundTapRecognizer];
    self.backgroundTapRecognizer = nil;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return section == 0 ? [self.trail.segments count] : [self.trail.trailheads count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];

    if ( indexPath.section == 0 ) {
        
        OTTrailSegment *segment = self.trail.segments[indexPath.row];
        
        cell.textLabel.text = [segment description];
        cell.textLabel.font = [UIFont PTAppFontOfSize:10.0f];
        cell.textLabel.numberOfLines = 3;
        
    } else if ( indexPath.section == 1 ) {
        
        OTTrailhead *trailhead = self.trail.trailheads[indexPath.row];
        
        cell.textLabel.text = trailhead.name;
        cell.textLabel.font = [UIFont PTAppFontOfSize:10.0f];
        cell.textLabel.numberOfLines = 1;
    
    }
    
    return cell;
}

#pragma mark UITableViewDelegate


#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    self.selectedSegment = self.trail.segments[row];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [self.trail.segments count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    OTTrailSegment *segment = self.trail.segments[row];
    UILabel *label = [UILabel new];
    
    label.font = [UIFont PTAppFontOfSize:18.0f];
    label.text = segment.name ?: DEFAULT_SEGMENT_NAME;
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 28.0f;
}

#pragma mark MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;
{
    PTTrailRenderer *renderer = [[PTTrailRenderer alloc] initWithOverlay:overlay];
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation;
{
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass( [self class] )];
    view.canShowCallout = YES;
    return view;
}

@end
