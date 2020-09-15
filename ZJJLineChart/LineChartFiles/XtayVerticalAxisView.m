//
//  VerticalAxisView.m
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

#import "XtayVerticalAxisView.h"

@implementation XtayVerticalAxisView

- (instancetype)initWithFrame:(CGRect)frame minValue:(CGFloat)minValue eachValue:(CGFloat)eachValue count:(int)count {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawLineYMinValue:minValue eachValue:eachValue count:count];
    }
    return self;
}

- (void)drawLineYMinValue:(CGFloat)minValue eachValue:(CGFloat)eachValue count:(int)count {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height-15)];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 5)];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width-5-5, 5)];
    /// 画线段、刻度
    if (eachValue == 0) {
        if (minValue == 0) {
            [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height-15)];
            [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-15)];
            [self customCreatLabelWithFrame:CGRectMake(0, self.frame.size.height-15-10, self.frame.size.width-10, 20) title:[self obtainStringWithFloat:0]];
        } else {
            count = 1;
            CGFloat totalHeight = self.frame.size.height - 30;
            CGFloat eachLength = totalHeight / count;
            [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height-15-eachLength*0)];
            [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-15-eachLength*0)];
            [self customCreatLabelWithFrame:CGRectMake(0, self.frame.size.height-15-eachLength*0-10, self.frame.size.width-10, 20) title:[self obtainStringWithFloat:0]];

            [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height-15-eachLength*1)];
            [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-15-eachLength*1)];
            [self customCreatLabelWithFrame:CGRectMake(0, self.frame.size.height-15-eachLength*1-10, self.frame.size.width-10, 20) title:[self obtainStringWithFloat:minValue]];
            
            [bezierPath stroke];
        }
    } else {
        CGFloat totalHeight = self.frame.size.height - 30;
        CGFloat eachLength = totalHeight / count;
        for (int i = 0; i<=count; i++) {
            [bezierPath moveToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height-15-eachLength*i)];
            [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-15-eachLength*i)];
            [self customCreatLabelWithFrame:CGRectMake(0, self.frame.size.height-15-eachLength*i-10, self.frame.size.width-10, 20) title:[self obtainStringWithFloat:minValue+(eachValue*i)]];
        }
        [bezierPath stroke];
    }
    
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
        [self customCreatLabelWithFrame:CGRectMake(0, 0, self.frame.size.width-10, 10) title:_unitString];
    }
}

- (NSString *)obtainStringWithFloat:(CGFloat)valueFloat {
    NSString *temp = [NSString stringWithFormat:@"%.1f", valueFloat];
    NSString *string = [NSString stringWithFormat:@"%g", [temp doubleValue]];
    return string;
}

- (void)customCreatLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = UIColor.clearColor;
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
