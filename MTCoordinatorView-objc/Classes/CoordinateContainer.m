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

@property (weak, readwrite, nonatomic) UIView *contentsView;

@property (assign, nonatomic) CGRect startForm;
@property (assign, nonatomic) CGRect endForm;

@property (assign, nonatomic) float topPadding;

@end

@implementation CoordinateContainer

#pragma mark - init

- (id)initView:(UIView *)contents endForm:(CGRect)endForm completion:(TapCompletion)completion
{
    if(self = [super init]){
        [self initialize:contents endForm:endForm completion:completion];
    }
    return self;
}

- (void)initialize:(UIView *)contents endForm:(CGRect)endForm completion:(TapCompletion)completion
{
    _topPadding = 0;
    _startForm = contents.frame;
    _endForm = endForm;
    self.frame = _startForm;
    _contentsView = contents;
    _contentsView.frame = CGRectMake(0, 0, _startForm.size.width, _startForm.size.height);
    [self addSubview:_contentsView];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    _tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    self.completion = completion;
}

#pragma mark - setter

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
//    NSLog(@"above ratio: %f", ratio);
    float newX = _endForm.origin.x + ((_startForm.origin.x - _endForm.origin.x) * ratio);
    float newY = _endForm.origin.y + ((_startForm.origin.y - _endForm.origin.y) * ratio);
    float newW = _endForm.size.width + ((_startForm.size.width - _endForm.size.width) * ratio);
    float newH = _endForm.size.height + ((_startForm.size.height - _endForm.size.height) * ratio);
    
    if(_startForm.origin.y < _endForm.origin.y){
        newY += scroll;
    }else if((newY - _topPadding) < _endForm.origin.y){
        newY = self.frame.origin.y;
    }
    
    CGRect newRect = CGRectMake(newX, newY, newW, newH);
    self.frame = newRect;
    _contentsView.frame = CGRectMake(0, 0, newW, newH);
}

- (void)scrolledToBelow:(float)ratio scroll:(float)scroll
{
//    NSLog(@"below ratio: %f", ratio);
    self.frame = CGRectMake(_startForm.origin.x,
                            _startForm.origin.y * fabs(ratio),
                            _startForm.size.width * fabs(ratio),
                            _startForm.size.height * fabs(ratio));
    _contentsView.frame = CGRectMake(0, 0, _startForm.size.width * fabs(ratio), _startForm.size.height * fabs(ratio));
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


#pragma mark - tap event

- (void)tapEvent
{
    if(self.completion != nil){
        self.completion();
    }
}

@end
