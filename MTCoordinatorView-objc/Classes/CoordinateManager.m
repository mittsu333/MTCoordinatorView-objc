//
//  CoordinateView.m
//  MTCoordinatorView-objc
//
//  Created by mittsu on 2016/08/29.
//  Copyright © 2016年 mittsu. All rights reserved.
//

#import "CoordinateManager.h"

@interface CoordinateManager ()

@property (retain) NSArray *viewArray;

//@property (assign, readwrite, nonatomic) NSInteger maxViewCnt;

@property (assign, readwrite, nonatomic) float viewHeight;
@property (assign, readwrite, nonatomic) float viewWidth;

@property (assign, readwrite, nonatomic) float statusNaviHeight;
@property (assign, readwrite, nonatomic) float newOriginY;

@property (weak, readwrite, nonatomic) UIView *headerView;

@end

@implementation CoordinateManager

#pragma mark - init

- (id)initMainContents:(UIViewController *)vc scroll:(UIScrollView *)scrollView header:(UIView *)headerView
{
    if(self = [super init]){
        [self initialize];
        [self setHeader:vc scroll:scrollView header:headerView];
    }
    return self;
}

- (void)initialize {
//    _maxViewCnt = 3;
}

#pragma mark - setter

- (void)setHeader:(UIViewController *)vc scroll:(UIScrollView *)scrollView header:(UIView *)headerView
{
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationBarHeight = vc.navigationController.navigationBar.frame.size.height;
    _statusNaviHeight = statusHeight + navigationBarHeight;
    
    _headerView = headerView;
    
    CGRect headerFrame = _headerView.frame;
    _viewHeight = headerFrame.size.height;
    _viewWidth = headerFrame.size.width;
    _newOriginY = headerFrame.origin.y - _viewHeight;
    headerView.frame = CGRectMake(headerFrame.origin.x, _newOriginY, _viewWidth, _viewHeight);

    scrollView.contentInset = UIEdgeInsetsMake(headerView.frame.size.height, 0, 0, 0);
    [scrollView addSubview:headerView];
}

- (void)setContainer:(UIScrollView *)scroll views:(CoordinateContainer *)views, ...NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    NSMutableArray* tmp = [NSMutableArray array];
    
    va_start(args, views);
    __unsafe_unretained id obj = views;
    
    while(obj){
        [tmp addObject:obj];
        obj = va_arg(args, typeof(id));
    }
    va_end(args);
    
    _viewArray = [tmp copy];
    [_viewArray enumerateObjectsUsingBlock:^(CoordinateContainer *view, NSUInteger idx, BOOL *stop){
        if(!view){
            *stop = YES;
        }else{
            [view setHeader:_statusNaviHeight transition:_viewHeight];
            [scroll addSubview:view];
        }
    }];
}

#pragma mark - scroll event

- (void)scrolledDetection:(UIScrollView *)scrollView
{
    float overScroll = scrollView.bounds.origin.y + scrollView.contentInset.top;
    if(overScroll < 0){
        [self belowDrawing:overScroll];

    }else if(overScroll > 0){
        [self aboveDrawing:overScroll];
        
    }else {
        _headerView.frame = CGRectMake(0, _newOriginY, _viewWidth, _viewHeight);
        [self.viewArray enumerateObjectsUsingBlock:^(CoordinateContainer *view, NSUInteger idx, BOOL *stop){
            if(!view){
                *stop = YES;
            }else{
                [view scrollReset];
            }
        }];
    }
}

- (void)belowDrawing:(float)overScroll
{
    _headerView.frame = CGRectMake(overScroll / 2,
                                   _newOriginY + overScroll,
                                   _viewWidth - overScroll,
                                   _viewHeight - overScroll
                                   );
    float ratio = (overScroll / (_viewHeight - _statusNaviHeight - overScroll)) - 1;
    
    [self.viewArray enumerateObjectsUsingBlock:^(CoordinateContainer *view, NSUInteger idx, BOOL *stop){
        if(!view){
            *stop = YES;
        }else{
            [view scrolledToBelow:ratio scroll:overScroll];
        }
    }];
}

- (void)aboveDrawing:(float)overScroll
{
    float ratio = 1 - (overScroll / (_viewHeight - _statusNaviHeight - overScroll));
    [self.viewArray enumerateObjectsUsingBlock:^(CoordinateContainer *view, NSUInteger idx, BOOL *stop){
        if(!view){
            *stop = YES;
        }else{
            [view scrolledToAbove:ratio scroll:overScroll];
        }
    }];
}

@end
