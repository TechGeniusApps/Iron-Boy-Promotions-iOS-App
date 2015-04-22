//
//  FeaturedPosters.h
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 4/8/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedPosters : UIViewController <UIScrollViewDelegate> {
    UIScrollView *posterScroller;
    UIPageControl *posterScrollerDots;
}

@end