//
//  PTCyclingTrailFinderViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTCyclingTrailFinderViewController.h"
#import "PTFilterCell.h"

@interface PTCyclingTrailFinderViewController ()

@end

@implementation PTCyclingTrailFinderViewController

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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];
    
    switch ( indexPath.row )
    {
        case 0:
            cell.textLabel.text = NSLocalizedString( @"I describe myself as a:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"bike commuter", @"" );
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString( @"I like trails that are:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"popular", @"" );
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString( @"Unpaved paths:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"avoid", @"" );
            break;
        case 3:
            cell.textLabel.text = NSLocalizedString( @"Traffic:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"avoid high speed limits", @"" );
            break;
        case 4:
            cell.textLabel.text = NSLocalizedString( @"Hills:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"avoid steep hills", @"" );
            break;
        case 5:
            cell.textLabel.text = NSLocalizedString( @"Protected crossings:", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"preferred", @"" );
            break;
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
