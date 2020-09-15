//
//  XtayLineChartView.h
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XtayLineChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame horizonAxisArr:(NSArray *)horizonArr verticalAxisArr:(NSArray *)verticalArr horUnit:(NSString *)horUnit verUnit:(NSString *)verUnit;

/// 是否显示渐变
@property (nonatomic, assign) BOOL doesShowGradientLayer;

@end

NS_ASSUME_NONNULL_END
