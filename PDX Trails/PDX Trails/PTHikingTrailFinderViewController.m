//
//  PTHikingTrailFinderViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTHikingTrailFinderViewController.h"
#import "PTFilterCell.h"

@interface PTHikingTrailFinderViewController ()

@end

@implementation PTHikingTrailFinderViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[PTFilterCell class] forCellReuseIdentifier:NSStringFromClass( [self class] )];
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];
    
    switch ( indexPath.row )
    {
        case 0:
            cell.textLabel.text = NSLocalizedString( @"Length of trail:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"5mi - 10mi", @"" );
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString( @"Hills:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"okay", @"" );
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString( @"Popularity:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"low-use", @"" );
            break;
        case 3:
            cell.textLabel.text = NSLocalizedString( @"Scenic:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"important", @"" );
            break;
        case 4:
            cell.textLabel.text = NSLocalizedString( @"Surrounding area:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"rural / farmland", @"" );
            break;
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
