//
//  VideoPlayer.m
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/24/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "VideoPlayer.h"

@interface VideoPlayer ()

@end

@implementation VideoPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    // View Styling
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    event = [[NL_Event alloc] init];
    [event populateEventInBackground:[NSNumber numberWithLong:self.eventID].stringValue fromAccount:[NSNumber numberWithLong:self.accountID].stringValue :^{
        [self constructLoadingView];
        [self constructVideoInfo];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self constructComments];
        }
        [self constructVideoPlayer];
    } :nil];
}

- (void)constructLoadingView {
    if ([[event.feed.data[0] objectForKey:@"type"] isEqualToString:@"video"]) {
        @autoreleasepool {
            @autoreleasepool {
                float partOfView = 2/3.0f;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    partOfView = 1.0f;
                }
                
                thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * partOfView, 9 / 16.0f * (self.view.bounds.size.width * partOfView))];
            }
            thumbnail.contentMode = UIViewContentModeScaleAspectFill;
            thumbnail.clipsToBounds = YES;
            thumbnail.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.view addSubview:thumbnail];
            
            loadingLabel = [[UILabel alloc] initWithFrame:thumbnail.bounds];
            loadingLabel.textAlignment = NSTextAlignmentCenter;
            loadingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            loadingLabel.adjustsFontSizeToFitWidth = YES;
            loadingLabel.text = @"Loading...";
            loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            if ([UIVisualEffectView class]) {
                UIBlurEffect *blurredEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                blurredView8 = [[UIVisualEffectView alloc] initWithEffect:blurredEffect];
                [blurredView8 setFrame:thumbnail.bounds];
                blurredView8.autoresizingMask = thumbnail.autoresizingMask;
                [self.view insertSubview:blurredView8 aboveSubview:thumbnail];
                
                UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blurredEffect]];
                [vibrancyEffectView setFrame:blurredView8.bounds];
                vibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                [vibrancyEffectView.contentView addSubview:loadingLabel];
                [blurredView8.contentView addSubview:vibrancyEffectView];
            } else {
                blurredView7 = [[UIToolbar alloc] initWithFrame:thumbnail.frame];
                blurredView7.barStyle = UIBarStyleBlack;
                blurredView7.autoresizingMask = thumbnail.autoresizingMask;
                [self.view insertSubview:blurredView7 aboveSubview:thumbnail];
                
                loadingLabel.textColor = [UIColor lightTextColor];
                [self.view insertSubview:loadingLabel aboveSubview:blurredView7];
            }
            
            if (![[[event.feed.data[0] objectForKey:@"data"] objectForKey:@"thumbnail_url"] isKindOfClass:[NSNull class]]) {
                NSString *url = [[event.feed.data[0] objectForKey:@"data"] objectForKey:@"thumbnail_url"];
                
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (data && !connectionError) {
                        thumbnail.image = [UIImage imageWithData:data];
                    }
                }];
            }
        }
    }
}

- (void)constructVideoInfo {
    poster = [[UIImageView alloc] initWithFrame:CGRectZero];
    poster.contentMode = UIViewContentModeRedraw;
    poster.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:poster];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:event.logo.url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data && !connectionError) {
            poster.image = [UIImage imageWithData:data];
            
            [poster setFrame:CGRectMake(15, thumbnail.bounds.size.height + 15, poster.image.size.width / poster.image.size.height * (self.view.bounds.size.height -  thumbnail.bounds.size.height - 15 - 15), self.view.bounds.size.height -  thumbnail.bounds.size.height - 15 - 15)];
            
            eventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(poster.frame.origin.x + poster.bounds.size.width + 15, poster.frame.origin.y, thumbnail.bounds.size.width - poster.frame.origin.x - poster.bounds.size.width - 15 - 15, poster.bounds.size.height / 4)];
            eventTitleLabel.text = event.full_name;
            eventTitleLabel.textColor = [UIColor lightTextColor];
            eventTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            eventTitleLabel.adjustsFontSizeToFitWidth = YES;
            [self.view addSubview:eventTitleLabel];
            
            @autoreleasepool {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEE LLL, d y h:mm z"];
                
                startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(poster.frame.origin.x + poster.bounds.size.width + 15, eventTitleLabel.frame.origin.y + eventTitleLabel.bounds.size.height, thumbnail.bounds.size.width - poster.frame.origin.x - poster.bounds.size.width - 15 - 15, poster.bounds.size.height / 4)];
                startDateLabel.text = [dateFormatter stringFromDate:event.start_time];
                startDateLabel.textColor = [UIColor lightTextColor];
                startDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                startDateLabel.adjustsFontSizeToFitWidth = YES;
                [self.view addSubview:startDateLabel];
                
                endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(poster.frame.origin.x + poster.bounds.size.width + 15, startDateLabel.frame.origin.y + startDateLabel.bounds.size.height, thumbnail.bounds.size.width - poster.frame.origin.x - poster.bounds.size.width - 15 - 15, poster.bounds.size.height / 4)];
                endDateLabel.text = [dateFormatter stringFromDate:event.end_time];
                endDateLabel.textColor = [UIColor lightTextColor];
                endDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                endDateLabel.adjustsFontSizeToFitWidth = YES;
                [self.view addSubview:endDateLabel];
            }
            
            @autoreleasepool {
                NSNumber *views = [[event.feed.data[0] objectForKey:@"data"] objectForKey:@"views"];
                
                viewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(poster.frame.origin.x + poster.bounds.size.width + 15, endDateLabel.frame.origin.y + endDateLabel.bounds.size.height, thumbnail.bounds.size.width - poster.frame.origin.x - poster.bounds.size.width - 15 - 15, poster.bounds.size.height / 4)];
                @autoreleasepool {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    viewCountLabel.text = [NSString stringWithFormat:@"%@ Views", [formatter stringFromNumber:views]];
                }
                viewCountLabel.textColor = [UIColor lightTextColor];
                viewCountLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                viewCountLabel.adjustsFontSizeToFitWidth = YES;
                [self.view addSubview:viewCountLabel];
            }
        }
    }];
}

- (void)constructComments {
    commentsController = [[UITableViewController alloc] init];
    
    float partOfView = 1/3.0f;
    
    commentsController.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * (1 - partOfView), 0, self.view.bounds.size.width * partOfView, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    commentsController.tableView.dataSource = self;
    commentsController.tableView.delegate = self;
    commentsController.tableView.backgroundView = nil;
    commentsController.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:commentsController.tableView];
    
    commentsController.refreshControl = [[UIRefreshControl alloc] init];
    commentsController.refreshControl.tintColor = [UIColor colorWithRed:229/255.0f green:46/255.0f blue:23/255.0f alpha:1.0f];
    [commentsController.refreshControl addTarget:self action:@selector(refreshComments) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshComments {
    [event populateEventInBackground:[NSNumber numberWithLong:self.eventID].stringValue fromAccount:[NSNumber numberWithLong:self.accountID].stringValue :^{
        [commentsController.tableView reloadData];
        [commentsController.refreshControl endRefreshing];
    } :nil];
}

- (void)constructVideoPlayer {
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[event getOptimalVideoURL]]];
    [player play];
    [player.view setFrame:thumbnail.bounds];
    player.view.backgroundColor = self.view.backgroundColor;
    player.controlStyle = MPMovieControlStyleEmbedded;
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateChanged) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fallbackWithNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - MPMoviePlayerController Notifications

- (void)loadStateChanged {
    if (player.loadState == MPMovieLoadStatePlaythroughOK || player.loadState == 3) {
        [thumbnail removeFromSuperview];
        thumbnail = nil;
        [loadingLabel removeFromSuperview];
        loadingLabel = nil;
        if ([UIVisualEffectView class]) {
            [blurredView8 removeFromSuperview];
            blurredView8 = nil;
        } else {
            [blurredView7 removeFromSuperview];
            blurredView7 = nil;
        }
        
        [self.view addSubview:player.view];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
                [player setFullscreen:YES animated:YES];
            }
        }
    }
}

- (void)fallbackWithNotification:(NSNotification *)notification {
    @autoreleasepool {
        NSNumber *finishReason = [notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        if ([finishReason integerValue] == MPMovieFinishReasonPlaybackError) {
            // Upload Error log to Parse
            @autoreleasepool {
                PFObject *object = [PFObject objectWithClassName:@"videoErrorLog"];
                object[@"extendedLogData"] = [[NSString alloc] initWithData:player.errorLog.extendedLogData encoding:player.errorLog.extendedLogDataStringEncoding];
                object[@"eventTitle"] = self.title;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!succeeded || error) {
                        [object saveEventually];
                    }
                }];
            }
            
            [loadingLabel removeFromSuperview];
            loadingLabel = nil;
            
            [player stop];
            [player.view removeFromSuperview];
            player = nil;
            
            @autoreleasepool {
                UILabel *errorTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, thumbnail.bounds.size.height/2-21, self.navigationController.view.frame.size.width, 21)];
                errorTitle.textColor = [UIColor greenColor];
                errorTitle.backgroundColor = [UIColor blackColor];
                errorTitle.font = [UIFont boldSystemFontOfSize:18.0f];
                errorTitle.textAlignment = NSTextAlignmentCenter;
                errorTitle.text = @"Error loading video";
                if ([UIVisualEffectView class]) {
                    @autoreleasepool {
                        UIVisualEffectView *vibrancyEffectView = (UIVisualEffectView *)blurredView8.contentView.subviews[0];
                        [vibrancyEffectView addSubview:errorTitle];
                    }
                } else {
                    [self.view insertSubview:errorTitle aboveSubview:blurredView7];
                }
            }
            
            @autoreleasepool {
                NSNumber *errorNumber = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
                NSError *error = [[notification userInfo] objectForKey:@"error"];
                
                UILabel *errorDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, thumbnail.bounds.size.height/2, self.navigationController.view.frame.size.width, thumbnail.bounds.size.height/2)];
                errorDescription.textColor = [UIColor greenColor];
                errorDescription.backgroundColor = [UIColor blackColor];
                errorDescription.font = [UIFont systemFontOfSize:16.0f];
                errorDescription.textAlignment = NSTextAlignmentCenter;
                errorDescription.numberOfLines = 0;
                errorDescription.text = [NSString stringWithFormat:@"Error %d (%@)\nPlease try again later", [errorNumber intValue], error.localizedDescription];
                if ([UIVisualEffectView class]) {
                    @autoreleasepool {
                        UIVisualEffectView *vibrancyEffectView = (UIVisualEffectView *)blurredView8.contentView.subviews[0];
                        [vibrancyEffectView addSubview:errorDescription];
                    }
                } else {
                    [self.view insertSubview:errorDescription aboveSubview:blurredView7];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[[[[[event.feed.data firstObject] objectForKey:@"data"] objectForKey:@"comments"] objectForKey:@"data"] objectAtIndex:section] objectForKey:@"author"] objectForKey:@"full_name"];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[[[[[event.feed.data firstObject] objectForKey:@"data"] objectForKey:@"comments"] objectForKey:@"data"] objectAtIndex:section] objectForKey:@"text"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[[[[event.feed.data firstObject] objectForKey:@"data"] objectForKey:@"comments"] objectForKey:@"data"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

@end