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
#import "PTSegmentTableViewCell.h"

#define DEFAULT_SEGMENT_NAME NSLocalizedString( @"Trailway", @"" );

static NSString *const PTTrailInfoCellIdentifier = @"PTTrailInfoCellIdentifier";
static NSString *const PTTrailSegmentCellIdentifier = @"PTTrailSegmentCellIdentifier";

@interface NSCountedSet(PTTrailInfoViewController)
- (id)mostFrequentElement;
@end

@implementation NSCountedSet(PTTrailInfoViewController)

- (id)mostFrequentElement;
{
    id best = nil;
    NSUInteger count = 0;
    
    for ( id element in self ) {
        if ( best == nil || [self countForObject:element] > count ) {
            best = element;
            count = [self countForObject:element];
        }
    }
    
    return best;
}

@end

@interface PTTrailInfoViewController ()

@property (strong, nonatomic) OTTrail *trail;
@property (strong, nonatomic) OTTrailSegment *selectedSegment;
@property (strong, nonatomic) NSArray *trailAttributes;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UISegmentedControl *detailModeControl;
@property (strong, nonatomic) UITableView *detailsTableView;
@property (strong, nonatomic) UITapGestureRecognizer *backgroundTapRecognizer;

+ (NSArray *)buildAttributes:(OTTrail *)trail;

- (void)changeMode:(UISegmentedControl *)sender;
- (void)backgroundTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation PTTrailInfoViewController

#pragma mark PTTrailInfoViewController

-(instancetype)initWithTrail:(OTTrail *)trail;
{
    NSParameterAssert( trail != nil );
    
    if ( self = [super initWithNibName:nil bundle:nil] ) {
        _trail = trail;
        _trailAttributes = [[self class] buildAttributes:trail];
    }
    
    return self;
}

#pragma mark PTTrailInfoViewController Private

+ (NSArray *)buildAttributes:(OTTrail *)trail;
{
    NSParameterAssert( trail!= nil );
    
    NSCountedSet *surfaceTags = [NSCountedSet new];
    
    for ( OTTrailSegment *segment in trail.segments ) {
        
        NSString *surface = segment.openStreetMapTags[@"surface"];
        
        if ( [surface length] > 0 )
            [surfaceTags addObject:surface];
    }
    
    NSMutableArray *strings = [NSMutableArray new];

    [strings addObject:[NSString stringWithFormat:NSLocalizedString( @"%.0f meters long.", @"" ), trail.distance]];
    [strings addObject:[NSString stringWithFormat:NSLocalizedString( @"Surface is mostly %@.", @"" ), [surfaceTags mostFrequentElement]]];
    
    return strings;
}

- (void)changeMode:(UISegmentedControl *)sender;
{
    [self.detailsTableView reloadData];
}

- (void)backgroundTap:(UITapGestureRecognizer *)recognizer;
{
    if ( recognizer.state != UIGestureRecognizerStateEnded )
        return;
    
    CGPoint location = [recognizer locationInView:self.view];
    
    if ( !CGRectContainsPoint( self.view.frame, location) )
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
    
//    PTOSMFormatter *formatter = [PTOSMFormatter new];
//    self.infoLabel.text = [formatter stringForTags:[selectedSegment openStreetMapTags]];
    
    _selectedSegment = selectedSegment;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *labels = @[NSLocalizedString( @"Trail Info", @"" ), NSLocalizedString( @"Segments", @"" )];
    self.detailModeControl = [[UISegmentedControl alloc] initWithItems:labels];
    self.detailModeControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailModeControl.tintColor = [UIColor PTBlueTintColor];
    self.detailModeControl.selectedSegmentIndex = 0;
    [self.detailModeControl addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventValueChanged];
    
    self.mapView = [MKMapView new];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.scrollEnabled = NO;
    
    PTTrailOverlay *overlay = [[PTTrailOverlay alloc] initWithTrail:self.trail];
    MKMapRect mapRect = overlay.boundingMapRect;
    mapRect = MKMapRectInset( mapRect, MKMapRectGetWidth( mapRect ) * -0.1, MKMapRectGetHeight( mapRect ) * -0.1 );
    
    [self.mapView addOverlay:overlay];
    [self.mapView setRegion:MKCoordinateRegionForMapRect( mapRect ) animated:YES];
    
    self.detailsTableView = [UITableView new];
    self.detailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    self.detailsTableView.sectionHeaderHeight = 30.0f;
    self.detailsTableView.sectionFooterHeight = 20.0f;
    [self.detailsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PTTrailInfoCellIdentifier];
    [self.detailsTableView registerClass:[PTSegmentTableViewCell class] forCellReuseIdentifier:PTTrailSegmentCellIdentifier];
    
    [self.view addSubview:self.detailModeControl];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.detailsTableView];

    NSDictionary *views = NSDictionaryOfVariableBindings( _mapView, _detailModeControl, _detailsTableView );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView(350)]-(20)-[_detailModeControl]-(20)-[_detailsTableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[_detailsTableView]-(40)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[_detailModeControl]-(40)-|" options:0 metrics:nil views:views]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    BOOL infoMode = self.detailModeControl.selectedSegmentIndex == 0;
    return infoMode ? [self.trailAttributes count] : [self.trail.segments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BOOL infoMode = self.detailModeControl.selectedSegmentIndex == 0;
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoMode ? PTTrailInfoCellIdentifier : PTTrailSegmentCellIdentifier forIndexPath:indexPath];

    if ( infoMode ) {
        
        cell.textLabel.text = self.trailAttributes[row];
        cell.textLabel.font = [UIFont PTAppFontOfSize:14.0f];
        cell.textLabel.numberOfLines = 1;
        
    } else {
        
        OTTrailSegment *segment = self.trail.segments[row];
        PTSegmentTableViewCell *real = cell;
        real.segment = segment;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel *label = [UILabel new];
    label.font = [UIFont PTBoldAppFontOfSize:12.0f];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.trail.name ?: NSLocalizedString( @"Trail", @"" );
    label.text = [label.text uppercaseString];
    
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.selectedSegment = self.trail.segments[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if ( self.detailModeControl.selectedSegmentIndex != 1 )
        return;
    
    NSArray *cells = [self.detailsTableView visibleCells];
    PTSegmentTableViewCell *cell = [cells firstObject];
    self.selectedSegment = cell.segment;
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
