//
//  XtayLineChartView.m
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

/// 默认纵轴分割段数
#define VERTICAL_PART_COUNT    5
/// 默认纵轴视图宽度
#define VERTICAL_VIEW_WIDTH    30

#import "XtayLineChartView.h"
#import "XtayVerticalAxisView.h"
#import "XtayHorizonAxisView.h"
#import "XtayLineScrollView.h"

@interface XtayLineChartView ()

/// 横轴
@property (nonatomic, copy) NSArray *horizonArr;
/// 纵轴
@property (nonatomic, copy) NSArray *verticalArr;
/// UI
@property (nonatomic, strong) XtayVerticalAxisView *verView;
/// UI
@property (nonatomic, strong) XtayHorizonAxisView *horView;
/// UI
@property (nonatomic, strong) XtayLineScrollView *scrollView;
/// 每段代表的值
@property (nonatomic, assign) CGFloat eachValueFloat;
/// 纵轴单位
@property (nonatomic, copy) NSString *verUnit;
/// 横轴单位
@property (nonatomic, copy) NSString *horUnit;

@end

@implementation XtayLineChartView

- (instancetype)initWithFrame:(CGRect)frame horizonAxisArr:(NSArray *)horizonArr verticalAxisArr:(NSArray *)verticalArr horUnit:(NSString *)horUnit verUnit:(NSString *)verUnit
{
    self = [super initWithFrame:frame];
    if (self) {
        self.horizonArr = horizonArr;
        self.verticalArr = verticalArr;
        self.horUnit = horUnit;
        self.verUnit = verUnit;
        [self drawVerticalAxis];
        [self drawHorizonAxis];
        [self customAddScrollView];
    }
    return self;
}

- (void)drawVerticalAxis {
    CGFloat minValue = [[_verticalArr valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat maxValue = [[_verticalArr valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat eachValue = (maxValue - minValue)/VERTICAL_PART_COUNT;
    int eachInt = eachValue;
    if (eachValue != eachInt) {
        eachValue = eachInt + 1;
    }
    self.eachValueFloat = eachValue;
    self.verView = [[XtayVerticalAxisView alloc] initWithFrame:CGRectMake(0, 0, VERTICAL_VIEW_WIDTH, self.frame.size.height) minValue:minValue eachValue:eachValue count:VERTICAL_PART_COUNT];
    _verView.backgroundColor = [UIColor clearColor];
    _verView.unitString = _verUnit;
    [self addSubview:_verView];
}

- (void)drawHorizonAxis {
    self.horView = [[XtayHorizonAxisView alloc] initWithFrame:CGRectMake(VERTICAL_VIEW_WIDTH, self.frame.size.height-15-5, self.frame.size.width-VERTICAL_VIEW_WIDTH, 20)];
    _horView.backgroundColor = [UIColor clearColor];
    _horView.unitString = _horUnit;
    [self addSubview:_horView];
}

- (void)customAddScrollView {
    self.scrollView = [[XtayLineScrollView alloc] initWithFrame:CGRectMake(VERTICAL_VIEW_WIDTH, 0, self.frame.size.width-VERTICAL_VIEW_WIDTH, self.frame.size.height) horizonAxisArr:_horizonArr verticalAxisArr:_verticalArr eachValue:_eachValueFloat count:VERTICAL_PART_COUNT horUnit:_horUnit verUnit:_verUnit];
    _scrollView.pagingEnabled = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void)setDoesShowGradientLayer:(BOOL)doesShowGradientLayer {
    _doesShowGradientLayer = doesShowGradientLayer;
    self.scrollView.doesShowGradientLayer = _doesShowGradientLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
