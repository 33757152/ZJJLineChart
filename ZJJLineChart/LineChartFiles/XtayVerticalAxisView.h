//
//  VerticalAxisView.h
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XtayVerticalAxisView : UIView

- (instancetype)initWithFrame:(CGRect)frame minValue:(CGFloat)minValue eachValue:(CGFloat)eachValue count:(int)count;

/// 单位
@property (nonatomic, copy) NSString *unitString;

@end

NS_ASSUME_NONNULL_END
