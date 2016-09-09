//
//  CoordinateContainer.h
//  MTCoordinatorView-objc
//
//  Created by mittsu on 2016/08/29.
//  Copyright © 2016年 mittsu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, kSmoothMode){
    kSmoothModeNone,
    kSmoothModeFixity
};

@interface CoordinateContainer : UIView<UIGestureRecognizerDelegate>

typedef void (^TapCompletion)();

- (id)init __attribute__((unavailable("init is not available")));
- (id)initView:(UIView *)contents endForm:(CGRect)endForm completion:(TapCompletion)completion;
- (id)initView:(UIView *)contents endForm:(CGRect)endForm corner:(float)corner completion:(TapCompletion)completion;
- (id)initView:(UIView *)contents endForm:(CGRect)endForm mode:(kSmoothMode)mode completion:(TapCompletion)completion;
- (id)initView:(UIView *)contents endForm:(CGRect)endForm corner:(float)corner mode:(kSmoothMode)mode completion:(TapCompletion)completion;

- (void)setHeader:(float)systemHeight transition:(float)transitionHeight;
- (CGRect)startForm;
- (CGRect)endForm;

- (void)scrollReset;

- (void)scrolledToAbove:(float)ratio scroll:(float)scroll;
- (void)scrolledToBelow:(float)ratio scroll:(float)scroll;
//- (void)scrolledToLeft:(float)ratio;
//- (void)scrolledToRight:(float)ratio;

@end
