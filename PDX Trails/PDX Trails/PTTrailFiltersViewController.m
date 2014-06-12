//
//  PTTrailFiltersViewController.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailFiltersViewController.h"
#import "PTFilterCell.h"
#import "PTTrailFilterSelectionViewController.h"
#import "PTAttribute.h"

@interface PTTrailFiltersViewController ()
@end

@implementation PTTrailFiltersViewController

#pragma mark PTTrailFiltersViewController

- (instancetype)initWithFilterAttributes:(NSArray *)attributes;
{
    if ( self = [super initWithStyle:UITableViewStylePlain] ) {
        
        self.clearsSelectionOnViewWillAppear = YES;
        
        _attributes = attributes;
    }
    
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[PTFilterCell class] forCellReuseIdentifier:NSStringFromClass( [self class] )];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];
    
    switch ( indexPath.row )
    {
        case 0:
            cell.textLabel.text = NSLocalizedString( @"Nearby parking:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"important", @"" );
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString( @"Hills:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"avoid", @"" );
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString( @"Protected crossings:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"important", @"" );
            break;
        case 3:
            cell.textLabel.text = NSLocalizedString( @"Unpaved trails:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"avoid", @"" );
            break;
        case 4:
            cell.textLabel.text = NSLocalizedString( @"Connected to sidewalks:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"important", @"" );
            break;
        default:
            break;
    }
        
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    PTAttribute *attribute = self.attributes[indexPath.row];
    PTTrailFilterSelectionViewController *controller = [[PTTrailFilterSelectionViewController alloc] initWithAttribute:attribute];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
