//
//  VideoList.h
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/22/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NL_API.h"

@interface VideoList : UITableViewController {
    NL_Account *account;
}

- (void)refresh;

@end