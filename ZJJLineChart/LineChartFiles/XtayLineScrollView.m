//
//  XtayLineScrollView.m
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

/// 点点之间的间距
#define POINT_POINT_EDGE_X   10.0f
#define LEFT_OFFSET_X        15.0f

#import "XtayLineScrollView.h"
#import "XtayShowResultView.h"

@interface XtayLineScrollView ()

/// 横轴
@property (nonatomic, copy) NSArray *horizonArr;
/// 纵轴
@property (nonatomic, copy) NSArray *verticalArr;
/// 每段代表的值
@property (nonatomic, assign) CGFloat eachValueFloat;
/// 最小值
@property (nonatomic, assign) CGFloat minValue;
/// 数量
@property (nonatomic, assign) int count;
/// 上一个（显示的）控件MaxX点
@property (nonatomic, assign) CGFloat used_X;
/// 显示的竖线
@property (nonatomic, strong) UIView *verLineView;
/// 纵轴单位
@property (nonatomic, copy) NSString *verUnit;
/// 横轴单位
@property (nonatomic, copy) NSString *horUnit;
/// 显示结果的视图
@property (nonatomic, strong) XtayShowResultView *resultView;
/// 圆圈
@property (nonatomic, strong) UIView *circleView;

@end

@implementation XtayLineScrollView

- (instancetype)initWithFrame:(CGRect)frame horizonAxisArr:(nonnull NSArray *)horizonArr verticalAxisArr:(nonnull NSArray *)verticalArr eachValue:(CGFloat)eachValue count:(int)count horUnit:(nonnull NSString *)horUnit verUnit:(nonnull NSString *)verUnit
{
    self = [super initWithFrame:frame];
    if (self) {
        self.used_X = 0.f;
        self.horizonArr = horizonArr;
        self.verticalArr = verticalArr;
        self.eachValueFloat = eachValue;
        self.horUnit = horUnit;
        self.verUnit = verUnit;
        self.count = count;
        self.minValue = [[verticalArr valueForKeyPath:@"@min.floatValue"] floatValue];
        [self beginDrawLinePath];
        [self beginAddLongPressGesture];
    }
    return self;
}

- (void)beginDrawLinePath {
    if (self.verticalArr.count != self.horizonArr.count) {
        // 横纵数据不等
        return;
    }
    if (self.verticalArr.count == 0) {
        // 横纵都为空数组
        return;
    }
    if (_eachValueFloat == 0) {
        // 纵轴值都一样
        if (_minValue == 0) {
            // 纵轴所有值都是0
            CGFloat totalLength_w = POINT_POINT_EDGE_X*_horizonArr.count + LEFT_OFFSET_X + 20;
            for (NSInteger i = 0; i<_verticalArr.count; i++) {
                CGFloat x = LEFT_OFFSET_X+POINT_POINT_EDGE_X*i;
                /// draw number
                [self beginDrawNumberXWithIndex:i withX:x];
            }
            self.contentSize = CGSizeMake(totalLength_w, 0);
        } else {
            // 纵轴所有值都一样，但非0
            CGFloat totalLength_w = POINT_POINT_EDGE_X*_horizonArr.count + LEFT_OFFSET_X + 20;
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            for (NSInteger i = 0; i<_verticalArr.count; i++) {
                CGFloat y = 15;
                CGFloat x = LEFT_OFFSET_X+POINT_POINT_EDGE_X*i;
                if (i == 0) {
                    [bezierPath moveToPoint:CGPointMake(x, y)];
                } else {
                    [bezierPath addLineToPoint:CGPointMake(x, y)];
                }
                /// draw number
                [self beginDrawNumberXWithIndex:i withX:x];
            }
            [bezierPath stroke];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.lineWidth = 1.f;
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
            shapeLayer.frame = CGRectMake(0, 0, totalLength_w, self.frame.size.height);
            shapeLayer.path = bezierPath.CGPath;
            [self.layer addSublayer:shapeLayer];
            
            self.contentSize = CGSizeMake(totalLength_w, 0);
        }
    } else {
        // 正常情况
        CGFloat totalLength_w = POINT_POINT_EDGE_X*_horizonArr.count + LEFT_OFFSET_X + 20;
        CGFloat eachHeight = (self.frame.size.height - 30)/_count;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<_verticalArr.count; i++) {
            CGFloat yValue = [_verticalArr[i] floatValue];
            CGFloat length = (yValue - _minValue) * eachHeight/_eachValueFloat;
            CGFloat y = self.frame.size.height - 15 - length;
            CGFloat x = LEFT_OFFSET_X+POINT_POINT_EDGE_X*i;
            if (i == 0) {
                [bezierPath moveToPoint:CGPointMake(x, y)];
            } else {
                [bezierPath addLineToPoint:CGPointMake(x, y)];
            }
            /// draw number
            [self beginDrawNumberXWithIndex:i withX:x];
        }
        [bezierPath stroke];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 1.f;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
        shapeLayer.frame = CGRectMake(0, 0, totalLength_w, self.frame.size.height);
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        self.contentSize = CGSizeMake(totalLength_w, 0);
    }
}

- (void)beginDrawNumberXWithIndex:(NSInteger)index withX:(CGFloat)x {
    NSString *number = [_horizonArr objectAtIndex:index];
    CGFloat w = [number boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XTAY_FONT_WEIGHT(8, 0)} context:nil].size.width;
    if (x - w/2 < _used_X) {
        return;
    }
    UILabel *label = [self customLabelTitle:number];
    label.center = CGPointMake(x, self.frame.size.height-5);
    label.bounds = CGRectMake(0, 0, w, 10);
    [self addSubview:label];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.center = CGPointMake(x, self.frame.size.height-15-5/2);
    lineView.bounds = CGRectMake(0, 0, 1, 5);
    [self addSubview:lineView];
    
    self.used_X = x + w/2;
}

- (void)drawGradientLayer {
    if (self.horizonArr.count != self.verticalArr.count) {
        return;
    }
    if (self.horizonArr.count == 0) {
        return;
    }
    if (_eachValueFloat == 0) {
        if (_minValue == 0) {
            return;
        }
        CGFloat totalLength_w = POINT_POINT_EDGE_X*_horizonArr.count + LEFT_OFFSET_X + 20;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<_verticalArr.count; i++) {
            CGFloat y = 15;
            CGFloat x = LEFT_OFFSET_X+POINT_POINT_EDGE_X*i;
            if (i == 0) {
                [bezierPath moveToPoint:CGPointMake(x, self.frame.size.height-15)];
            }
            [bezierPath addLineToPoint:CGPointMake(x, y)];
            if (i == _verticalArr.count - 1) {
                [bezierPath addLineToPoint:CGPointMake(x, self.frame.size.height-15)];
                [bezierPath closePath];
                [bezierPath stroke];
            }
        }
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 1.f;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
        shapeLayer.frame = CGRectMake(0, 0, totalLength_w, self.frame.size.height);
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, totalLength_w, self.frame.size.height);
        gradientLayer.locations = @[@0, @1];
        gradientLayer.colors = @[(__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.05].CGColor,
                                 (__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor
        ];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:shapeLayer];
        [self.layer addSublayer:gradientLayer];
    } else {
        CGFloat totalLength_w = POINT_POINT_EDGE_X*_horizonArr.count + LEFT_OFFSET_X + 20;
        CGFloat eachHeight = (self.frame.size.height - 30)/_count;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<_verticalArr.count; i++) {
            CGFloat yValue = [_verticalArr[i] floatValue];
            CGFloat length = (yValue - _minValue) * eachHeight/_eachValueFloat;
            CGFloat y = self.frame.size.height - 15 - length;
            CGFloat x = LEFT_OFFSET_X+POINT_POINT_EDGE_X*i;
            if (i == 0) {
                [bezierPath moveToPoint:CGPointMake(x, self.frame.size.height-15)];
            }
            [bezierPath addLineToPoint:CGPointMake(x, y)];
            if (i == _verticalArr.count - 1) {
                [bezierPath addLineToPoint:CGPointMake(x, self.frame.size.height-15)];
                [bezierPath closePath];
                [bezierPath stroke];
            }
        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 1.f;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
        shapeLayer.frame = CGRectMake(0, 0, totalLength_w, self.frame.size.height);
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, totalLength_w, self.frame.size.height);
        gradientLayer.locations = @[@0, @1];
        gradientLayer.colors = @[(__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.05].CGColor,
                                 (__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor
        ];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:shapeLayer];
        [self.layer addSublayer:gradientLayer];
    }
}

- (void)beginAddLongPressGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    if (self.horizonArr.count != self.verticalArr.count) {
        return;
    }
    if (self.horizonArr.count == 0) {
        return;
    }
    [self addGestureRecognizer:longPress];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.scrollEnabled = NO;
        [self addSubview:self.verLineView];
        CGPoint point = [gesture locationInView:self];
        NSInteger index = [self obtainCurrentShowIndex:point.x];
        _verLineView.center = CGPointMake(LEFT_OFFSET_X+index*POINT_POINT_EDGE_X, self.bounds.size.height/2);
        
        [self addSubview:self.circleView];
        CGFloat y = [self obtainYWithIndex:index];
        _circleView.center = CGPointMake(LEFT_OFFSET_X+index*POINT_POINT_EDGE_X, y);
            
        [self addSubview:self.resultView];
        _resultView.xStr = [NSString stringWithFormat:@"%@: %@", _horUnit, self.horizonArr[index]];
        _resultView.yStr = [NSString stringWithFormat:@"%@: %@", _verUnit, self.verticalArr[index]];
        _resultView.frame = [self obtainRectWithX:LEFT_OFFSET_X+index*POINT_POINT_EDGE_X y:y strx:_resultView.xStr stry:_resultView.yStr];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:self];
        NSInteger index = [self obtainCurrentShowIndex:point.x];
        _verLineView.center = CGPointMake(LEFT_OFFSET_X+index*POINT_POINT_EDGE_X, self.bounds.size.height/2);
        
        CGFloat y = [self obtainYWithIndex:index];
        _circleView.center = CGPointMake(LEFT_OFFSET_X+index*POINT_POINT_EDGE_X, y);
        
        _resultView.xStr = [NSString stringWithFormat:@"%@: %@", _horUnit, self.horizonArr[index]];
        _resultView.yStr = [NSString stringWithFormat:@"%@: %@", _verUnit, self.verticalArr[index]];
        _resultView.frame = [self obtainRectWithX:LEFT_OFFSET_X+index*POINT_POINT_EDGE_X y:y strx:_resultView.xStr stry:_resultView.yStr];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.scrollEnabled = YES;
        [self.verLineView removeFromSuperview];
        [self.circleView removeFromSuperview];
        [self.resultView removeFromSuperview];
    }
}

- (CGRect)obtainRectWithX:(CGFloat)x y:(CGFloat)y strx:(NSString *)strx stry:(NSString *)stry {
    CGFloat resultH = 40;
    CGFloat width1 = [strx boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, resultH/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XTAY_FONT_WEIGHT(RESULT_FONT_VALUE_FLOAT, 0)} context:nil].size.width;
    CGFloat width2 = [stry boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, resultH/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XTAY_FONT_WEIGHT(RESULT_FONT_VALUE_FLOAT, 0)} context:nil].size.width;
    CGFloat resultW = MAX(width1, width2) + 5;
    CGFloat resultX = x+5;
    CGFloat resultY = y+5;
    if (x+resultW-self.contentOffset.x > self.frame.size.width) {
        resultX = x - resultW - 5;
    }
    if (resultY+resultH > self.frame.size.height) {
        resultY = y - resultH - 5;
    }
    return CGRectMake(resultX, resultY, resultW, resultH);
}

- (CGFloat)obtainYWithIndex:(NSInteger)index {
    if (_eachValueFloat == 0) {
        if (_minValue == 0) {
            return self.frame.size.height-15;
        }
        return 15.f;
    }
    CGFloat eachHeight = (self.frame.size.height - 30)/_count;
    CGFloat yValue = [_verticalArr[index] floatValue];
    CGFloat length = (yValue - _minValue) * eachHeight/_eachValueFloat;
    CGFloat y = self.frame.size.height - 15 - length;
    return y;
}

- (NSInteger)obtainCurrentShowIndex:(CGFloat)pointX {
    CGFloat tempIndex0 = (pointX - LEFT_OFFSET_X)/POINT_POINT_EDGE_X;
    NSInteger index = tempIndex0;
    if (tempIndex0 - index >= 0.5) {
        index += 1;
    }
    if (index > _horizonArr.count - 1 && index > 0) {
        index = _horizonArr.count - 1;
    }
    if (index < 0) {
        index = 0;
    }
    return index;
}

- (UILabel *)customLabelTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = UIColor.clearColor;
    label.font = XTAY_FONT_WEIGHT(8, 0);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;

    return label;
}

- (UIView *)verLineView {
    if (!_verLineView) {
        _verLineView = [[UIView alloc] init];
        _verLineView.backgroundColor = [UIColor blueColor];
        _verLineView.bounds = CGRectMake(0, 0, 1, self.frame.size.height-30);
    }
    return _verLineView;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = [UIColor clearColor];
        _circleView.bounds = CGRectMake(0, 0, 5, 5);
        _circleView.layer.cornerRadius = 5.0/2;
        _circleView.clipsToBounds = YES;
        _circleView.layer.borderColor = [UIColor blueColor].CGColor;
        _circleView.layer.borderWidth = 0.8f;
    }
    return _circleView;
}

- (XtayShowResultView *)resultView {
    if (!_resultView) {
        _resultView = [[XtayShowResultView alloc] init];
    }
    return _resultView;
}

- (void)setDoesShowGradientLayer:(BOOL)doesShowGradientLayer {
    _doesShowGradientLayer = doesShowGradientLayer;
    if (_doesShowGradientLayer) {
        [self drawGradientLayer];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
