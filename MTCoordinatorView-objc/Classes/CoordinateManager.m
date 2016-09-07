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

@property (assign, readwrite, nonatomic) float parentViewHeight;

@property (assign, readwrite, nonatomic) float headerViewHeight;
@property (assign, readwrite, nonatomic) float headerViewWidth;

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
    _headerViewHeight = 0;
    _headerViewWidth = 0;
    _newOriginY = 0;
}

#pragma mark - setter

- (void)setHeader:(UIViewController *)vc scroll:(UIScrollView *)scrollView header:(UIView *)headerView
{
    _parentViewHeight = vc.view.frame.size.height;
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationBarHeight = vc.navigationController.navigationBar.frame.size.height;
    _statusNaviHeight = statusHeight + navigationBarHeight;
    
    if(_headerView = headerView){
        CGRect headerFrame = _headerView.frame;
        _headerViewHeight = headerFrame.size.height;
        _headerViewWidth = headerFrame.size.width;
        _newOriginY = headerFrame.origin.y - _headerViewHeight;
        headerView.frame = CGRectMake(headerFrame.origin.x, _newOriginY, _headerViewWidth, _headerViewHeight);
        
        scrollView.contentInset = UIEdgeInsetsMake(headerView.frame.size.height, 0, 0, 0);
        [scrollView addSubview:headerView];
    }
}

- (void)setContainer:(UIScrollView *)scroll views:(NSArray<CoordinateContainer *> *)views
{
//    va_list args;
//    NSMutableArray* tmp = [NSMutableArray array];
//    
//    va_start(args, views);
//    __unsafe_unretained id obj = views;
//    
//    while(obj){
//        [tmp addObject:obj];
//        obj = va_arg(args, typeof(id));
//    }
//    va_end(args);
//    
//    _viewArray = [tmp copy];
    
    _viewArray = views;
    [_viewArray enumerateObjectsUsingBlock:^(CoordinateContainer *view, NSUInteger idx, BOOL *stop){
        if(!view){
            *stop = YES;
        }else{
            [view setHeader:_statusNaviHeight transition:_headerViewHeight];
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
        
        if(_headerView){
            _headerView.frame = CGRectMake(0, _newOriginY, _headerViewWidth, _headerViewHeight);
        }
        
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
    if(_headerView){
        _headerView.frame = CGRectMake(overScroll / 2, _newOriginY + overScroll,
                                       _headerViewWidth - overScroll, _headerViewHeight - overScroll);
    }
    
    float ratio = 1 + fabs(overScroll / (_parentViewHeight + overScroll));
    
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
    [self.viewArray enumerateObjectsUsingBlock:^(CoordinateContainer *view, NSUInteger idx, BOOL *stop){
        if(!view){
            *stop = YES;
        }else{
            float sy = view.startForm.origin.y;
            float ey = view.endForm.origin.y;
            float yyy = (MAX(sy, ey) - MIN(sy, ey));
            float ratioY = 1 - (overScroll / yyy);
            if(ratioY == -INFINITY){
                ratioY = 1;
            }
            
            float sx = view.startForm.origin.x;
            float ex = view.endForm.origin.x;
            float xxx = (MAX(sx, ex) - MIN(sx, ex));
            float ratioX = 1 - (overScroll / (MAX(sx, ex) - MIN(sx, ex)));
            if(ratioX == -INFINITY){
                ratioX = 1;
            }
            float ratio = MAX(ratioX, ratioY);
            
            if(ratioX == 1 && ratioY == 1){
                float sw = view.startForm.size.width;
                float ew = view.endForm.size.width;
                float sh = view.startForm.size.height;
                float eh = view.endForm.size.height;
                
                float maxW = MAX(sw, ew);
                float maxH = MAX(sh, eh);
                
                ratio = 1 - fabs((overScroll / maxW) * (overScroll / maxH));
            }
            
            if(overScroll >= MAX(xxx, yyy)){
                ratio = 0;
            }
            
            [view scrolledToAbove:ratio scroll:overScroll];
        }
    }];
}

@end
