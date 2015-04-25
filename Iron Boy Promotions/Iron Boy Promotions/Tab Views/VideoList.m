//
//  VideoList.m
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/22/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import "VideoList.h"

@interface VideoList ()

@end

@implementation VideoList

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Videos";
        self.tabBarItem.image = [UIImage imageNamed:@"videoList"];
    }
    return self;
}

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
    if (![self.refreshControl isRefreshing]) {
        [self.refreshControl beginRefreshing];
    }
    if (self.refreshControl.attributedTitle) {
        self.refreshControl.attributedTitle = nil;
    }
    
    account = [[NL_Account alloc] init];
    [account populateAccountInBackground:@"5387154" :^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        // [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1-0)] withRowAnimation:UITableViewRowAnimationAutomatic];
    } :^(NSInteger statusCode, NSError *connectionError, NSError *jsonError) {
        NSString *error;
        if (connectionError) {
            error = connectionError.localizedDescription;
        } else if (jsonError) {
            error = jsonError.localizedDescription;
        }
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Please try again", error] attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
        [self.refreshControl endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1-0)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Upcoming & Live Events";
    } else {
        return @"Archived Events";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return account.upcoming_events.total.integerValue;
    } else {
        return account.past_events.total.integerValue;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Dark Cell
    cell.backgroundView = tableView.backgroundView;
    cell.backgroundColor = tableView.backgroundColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    // Configure the cell...
    cell.imageView.image = nil;
    cell.textLabel.numberOfLines = 3;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        @autoreleasepool {
            @autoreleasepool {
                NSURL *url = [NSURL URLWithString:[[[[account.upcoming_events.data[indexPath.row] objectForKey:@"logo"] objectForKey:@"small_url"] stringByReplacingOccurrencesOfString:@"170x255" withString:[NSString stringWithFormat:@"%.fx%.f", [[[account.upcoming_events.data[indexPath.row] objectForKey:@"logo"] objectForKey:@"width"] floatValue] / [[[account.upcoming_events.data[indexPath.row] objectForKey:@"logo"] objectForKey:@"height"] floatValue] * (100 * [[UIScreen mainScreen] scale]), 100 * [[UIScreen mainScreen] scale]]] stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (data && !error) {
                        cell.imageView.image = [UIImage imageWithData:data];
                    }
                    [cell setNeedsLayout];
                }];
            }
        }
        
        cell.textLabel.text = [account.upcoming_events.data[indexPath.row] objectForKey:@"full_name"];
        
        @autoreleasepool {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
            NSDate *date = [dateFormatter dateFromString:[account.upcoming_events.data[indexPath.row] objectForKey:@"start_time"]];
            
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
        }
    } else {
        @autoreleasepool {
            @autoreleasepool {
                NSURL *url = [NSURL URLWithString:[[[[account.past_events.data[indexPath.row] objectForKey:@"logo"] objectForKey:@"small_url"] stringByReplacingOccurrencesOfString:@"170x255" withString:[NSString stringWithFormat:@"%.fx%.f", [[[account.past_events.data[indexPath.row] objectForKey:@"logo"] objectForKey:@"width"] floatValue] / [[[account.past_events.data[indexPath.row] objectForKey:@"logo"] objectForKey:@"height"] floatValue] * (100 * [[UIScreen mainScreen] scale]), 100 * [[UIScreen mainScreen] scale]]] stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (data && !error) {
                        cell.imageView.image = [UIImage imageWithData:data];
                    }
                    [cell setNeedsLayout];
                }];
            }
        }
        
        cell.textLabel.text = [account.past_events.data[indexPath.row] objectForKey:@"full_name"];
        
        @autoreleasepool {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
            NSDate *date = [dateFormatter dateFromString:[account.past_events.data[indexPath.row] objectForKey:@"start_time"]];
            
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end