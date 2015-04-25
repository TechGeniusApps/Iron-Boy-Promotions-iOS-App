//
//  FighterStats.m
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/25/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import "FighterStats.h"

@interface FighterStats ()

@end

@implementation FighterStats

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup tableview color
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:41/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:229/255.0f green:46/255.0f blue:23/255.0f alpha:1.0f];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self refresh];
}

- (void)refresh {
    PFQuery *query = [PFQuery queryWithClassName:@"fighter_stats"];
    [query getObjectInBackgroundWithId:self.object.objectId block:^(PFObject *updatedObject, NSError *error) {
        if (updatedObject && !error) {
            self.object = updatedObject;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1 - 0)] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Info";
    } else {
        return @"Record";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 7;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Dark Cell
    cell.backgroundView = tableView.backgroundView;
    cell.backgroundColor = tableView.backgroundColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.object[@"name"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"DOB";
            @autoreleasepool {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"y-MM-dd"];
                
                NSDateComponents *DOBcomponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.object[@"dob"]];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Age %.f", [dateFormatter stringFromDate:self.object[@"dob"]], floor(components.year - DOBcomponents.year)];
            }
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Country";
            cell.detailTextLabel.text = self.object[@"country"];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Residence";
            cell.detailTextLabel.text = self.object[@"residence"];
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"BoxRec Global ID";
            if (self.object[@"boxrec_gid"]) {
                cell.detailTextLabel.text = self.object[@"boxrec_gid"];
            }
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"US ID";
            if (self.object[@"us_id"]) {
                cell.detailTextLabel.text = self.object[@"us_id"];
            }
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"Division";
            cell.detailTextLabel.text = self.object[@"division"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Won";
            
            NSNumber *number = self.object[@"won"];
            cell.detailTextLabel.text = number.stringValue;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Lost";
            
            NSNumber *number = self.object[@"lost"];
            cell.detailTextLabel.text = number.stringValue;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Draw";
            
            NSNumber *number = self.object[@"draw"];
            cell.detailTextLabel.text = number.stringValue;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Rounds Boxed";
            
            NSNumber *number = self.object[@"rounds_boxed"];
            cell.detailTextLabel.text = number.stringValue;
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"KO %";
            
            NSNumber *number = self.object[@"ko"];
            cell.detailTextLabel.text = number.stringValue;
        }
    }
    
    if (cell.detailTextLabel.text.length == 0) {
        cell.detailTextLabel.text = @"N/A";
    }
    
    return cell;
}

@end