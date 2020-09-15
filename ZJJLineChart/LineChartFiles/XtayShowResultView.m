//
//  XtayShowResultView.m
//  ZJJLineChart
//
//  Created by admin on 2020/9/14.
//  Copyright © 2020 xtayqria. All rights reserved.
//

#import "XtayShowResultView.h"

@interface XtayShowResultView ()

/// x
@property (nonatomic, strong) UILabel *xLabel;
/// y
@property (nonatomic, strong) UILabel *yLabel;

@end

@implementation XtayShowResultView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        [self customUI];
    }
    return self;
}

- (void)customUI {
    self.xLabel = [self customLabelTitle:@""];
    [self addSubview:_xLabel];
    
    self.yLabel = [self customLabelTitle:@""];
    [self addSubview:_yLabel];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _xLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
    _yLabel.frame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
}

- (void)setXStr:(NSString *)xStr {
    if (xStr) {
        _xStr = xStr;
        self.xLabel.text = _xStr;
    }
}

- (void)setYStr:(NSString *)yStr {
    if (yStr) {
        _yStr = yStr;
        self.yLabel.text = _yStr;
    }
}

- (UILabel *)customLabelTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = UIColor.clearColor;
    label.font = XTAY_FONT_WEIGHT(RESULT_FONT_VALUE_FLOAT, 0);
    label.textColor = [UIColor whiteColor];
    label.text = title;

    return label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
