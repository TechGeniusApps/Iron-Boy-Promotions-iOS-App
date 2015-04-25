//
//  VideoPlayer.h
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/24/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "NL_API.h"

@interface VideoPlayer : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NL_Event *event;
    
    UIImageView *thumbnail;
    UIVisualEffectView *blurredView8;
    UIToolbar *blurredView7;
    UILabel *loadingLabel;
    
    UIImageView *poster;
    UILabel *eventTitleLabel;
    UILabel *startDateLabel;
    UILabel *endDateLabel;
    UILabel *viewCountLabel;
    
    UITableViewController *commentsController;
    
    MPMoviePlayerController *player;
}

@property (nonatomic, getter=getAccountID) long accountID;
@property (nonatomic, getter=getEventID) long eventID;

- (void)constructLoadingView;
- (void)constructVideoInfo;
- (void)constructComments;
- (void)refreshComments;
- (void)constructVideoPlayer;

@end