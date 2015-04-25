//
//  Fighters.m
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/25/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "Fighters.h"

#import "FighterStats.h"

@interface Fighters ()

@end

@implementation Fighters

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Fighters";
        self.tabBarItem.image = [UIImage imageNamed:@"stats"];
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
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"fighter_stats"];
    query.limit = 1000;
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            content = objects;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Dark Cell
    cell.backgroundView = tableView.backgroundView;
    cell.backgroundColor = tableView.backgroundColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    @autoreleasepool {
        PFObject *object = content[indexPath.row];
        
        cell.textLabel.text = object[@"name"];
        cell.imageView.image = nil;
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:object[@"picture_url"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data && !connectionError) {
                cell.imageView.image = [UIImage imageWithData:data];
                [cell setNeedsLayout];
            }
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @autoreleasepool {
        FighterStats *stats = [[FighterStats alloc] init];
        stats.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        stats.object = content[indexPath.row];
        [self.navigationController pushViewController:stats animated:YES];
    }
}

@end