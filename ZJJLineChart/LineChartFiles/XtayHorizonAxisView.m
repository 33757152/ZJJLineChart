//
//  XtayHorizonAxisView.m
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

#import "XtayHorizonAxisView.h"

@implementation XtayHorizonAxisView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawLineX];
    }
    return self;
}

- (void)drawLineX {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 5)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 5)];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width, 5)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width-5, 5-5)];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width, 5)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width-5, 5+5)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1.f;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer];
}

- (void)setUnitString:(NSString *)unitString {
    if (unitString) {
        _unitString = unitString;
        [self customCreatLabelWithFrame:CGRectMake(self.frame.size.width-15, 10, 15, 10) title:_unitString];
    }
}

- (void)customCreatLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = XTAY_FONT_WEIGHT(8, 0);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = title;
    label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
