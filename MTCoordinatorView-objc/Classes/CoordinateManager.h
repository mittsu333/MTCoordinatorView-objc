//
//  CoordinateView.h
//  MTCoordinatorView-objc
//
//  Created by mittsu on 2016/08/29.
//  Copyright © 2016年 mittsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinateContainer.h"

@interface CoordinateManager : UIView

- (id)init __attribute__((unavailable("init is not available")));
- (id)initManager:(UIViewController *)viewController scroll:(UIScrollView *)scrollView;
- (id)initManager:(UIViewController *)viewController scroll:(UIScrollView *)scrollView header:(UIView *)headerView;

- (void)setContainer:(UIScrollView *)scroll views:(CoordinateContainer *)views, ...NS_REQUIRES_NIL_TERMINATION;
- (void)scrolledDetection:(UIScrollView *)scrollView;

@end
