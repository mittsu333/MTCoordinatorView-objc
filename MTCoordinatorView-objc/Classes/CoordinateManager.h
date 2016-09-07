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
- (id)initMainContents:(UIViewController *)viewController scroll:(UIScrollView *)scrollView header:(UIView *)headerView;

- (void)setContainer:(UIScrollView *)scroll views:(NSArray<CoordinateContainer *> *)views;
- (void)scrolledDetection:(UIScrollView *)scrollView;

@end
