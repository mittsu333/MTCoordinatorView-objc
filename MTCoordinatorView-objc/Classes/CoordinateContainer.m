//
//  CoordinateContainer.m
//  MTCoordinatorView-objc
//
//  Created by mittsu on 2016/08/29.
//  Copyright © 2016年 mittsu. All rights reserved.
//

#import "CoordinateContainer.h"

@interface CoordinateContainer ()

@property (copy, nonatomic) TapCompletion completion;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, readwrite, nonatomic) UIView *contentsView;

@property (nonatomic) kSmoothMode *smoothMode;

@property (assign, nonatomic) CGRect startForm;
@property (assign, nonatomic) CGRect endForm;

@property (assign, nonatomic) float topPadding;
@property (assign, nonatomic) float cornerRadius;
@property (assign, nonatomic) float scrollDifference;

@end

@implementation CoordinateContainer

#pragma mark - init

- (id)initView:(UIView *)contents endForm:(CGRect)endForm completion:(TapCompletion)completion
{
    return [self initView:contents endForm:endForm corner:0.0 mode:kSmoothModeNone completion:completion];
}

- (id)initView:(UIView *)contents endForm:(CGRect)endForm corner:(float)corner completion:(TapCompletion)completion
{
    return [self initView:contents endForm:endForm corner:corner mode:kSmoothModeNone completion:completion];
}

- (id)initView:(UIView *)contents endForm:(CGRect)endForm mode:(kSmoothMode)mode completion:(TapCompletion)completion
{
    return [self initView:contents endForm:endForm corner:0.0 mode:mode completion:completion];
}

- (id)initView:(UIView *)contents endForm:(CGRect)endForm corner:(float)corner mode:(kSmoothMode)mode completion:(TapCompletion)completion
{
    if(self = [super init]){
        [self initialize:contents endForm:endForm corner:corner mode:mode completion:completion];
    }
    return self;
}

- (void)initialize:(UIView *)contents endForm:(CGRect)endForm corner:(float)corner mode:(kSmoothMode)mode completion:(TapCompletion)completion
{
    _smoothMode = mode;
    
    _topPadding = 0;
    _startForm = contents.frame;
    _endForm = endForm;
    self.frame = _startForm;
    _contentsView = contents;
    _contentsView.frame = CGRectMake(0, 0, _startForm.size.width, _startForm.size.height);
    [self addSubview:_contentsView];
    
    if(corner > 0 && corner <= 1){
        _cornerRadius = corner;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    _tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    self.completion = completion;
}

#pragma mark - set header view

- (void)setHeader:(float)systemHeight transition:(float)transitionHeight
{
    _topPadding = systemHeight;
    _startForm = CGRectOffset(_startForm, 0, -transitionHeight);
    _endForm = CGRectOffset(_endForm, 0, -transitionHeight);
    self.frame = _startForm;
    _contentsView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - get parameter

- (CGRect)startForm
{
    return _startForm;
}

- (CGRect)endForm
{
    return _endForm;
}

#pragma mark - scroll event

- (void)scrollReset
{
    self.frame = _startForm;
    _contentsView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)scrolledToAbove:(float)ratio scroll:(float)scroll
{
    if(ratio < 0 || ratio > 1){
        ratio = 0;
    }
    float newX = _endForm.origin.x + ((_startForm.origin.x - _endForm.origin.x) * ratio);
    float newY = _endForm.origin.y + ((_startForm.origin.y - _endForm.origin.y) * ratio);
    float newW = _endForm.size.width + ((_startForm.size.width - _endForm.size.width) * ratio);
    float newH = _endForm.size.height + ((_startForm.size.height - _endForm.size.height) * ratio);
    
    if(ratio == 0 && _scrollDifference != 0){
        newY += _topPadding + scroll - _scrollDifference;
    }else if(_startForm.origin.y < _endForm.origin.y){
        newY += scroll;
    }else if((newY - _topPadding) < _endForm.origin.y){
        newY = self.frame.origin.y;
    }
    
    if(newW < _endForm.size.width){
        newX += (_endForm.size.width - newW) / 2;
    }
    
    CGRect newRect = CGRectMake(newX, newY, newW, newH);
    self.frame = newRect;
    _contentsView.frame = CGRectMake(0, 0, newW, newH);
    
    [self updateRadiusSize:newW height:newH];
    
    [self applySmoothMode:ratio scroll:scroll];
}

- (void)scrolledToBelow:(float)ratio scroll:(float)scroll
{
    float newW = _startForm.size.width * fabs(ratio);
    float newH = _startForm.size.height * fabs(ratio);
    float smoothX = (_startForm.size.width - newW) / 2;
    
    self.frame = CGRectMake(_startForm.origin.x,
                            _startForm.origin.y * fabs(ratio),
                            newW, newH);
    _contentsView.frame = CGRectMake(smoothX, 0, newW, newH);
    
    [self updateRadiusSize:newW height:newH];
}

//- (void)scrolledToLeft:(float)ratio
//{
//    
//}
//
//- (void)scrolledToRight:(float)ratio
//{
//    
//}

#pragma mark - update raduis size

- (void)updateRadiusSize:(float)width height:(float)height
{
    if(_cornerRadius > 0){
        float newRadius = MAX(width, height) * _cornerRadius;
        self.layer.cornerRadius = newRadius;
        _contentsView.layer.cornerRadius = newRadius;
    }
}

#pragma mark - smooth option

- (void)applySmoothMode:(float)ratio scroll:(float)scroll
{
    if(_smoothMode != kSmoothModeFixity){
        return;
    }

    if(ratio == 0 && _scrollDifference == 0){
        _scrollDifference = scroll;
    }else if(ratio != 0 && _scrollDifference != 0){
        _scrollDifference = 0;
    }
}

#pragma mark - tap event

- (void)tapEvent
{
    if(self.completion != nil){
        self.completion();
    }
}

@end
