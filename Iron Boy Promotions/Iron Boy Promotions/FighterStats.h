//
//  FighterStats.h
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/25/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface FighterStats : UITableViewController

- (void)refresh;

@property (nonatomic, strong) PFObject *object;

@end