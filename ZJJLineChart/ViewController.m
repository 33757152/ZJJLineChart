//
//  ViewController.m
//  ZJJLineChart
//
//  Created by admin on 2020/9/9.
//  Copyright © 2020 xtayqria. All rights reserved.
//

#import "ViewController.h"
#import "XtayLineChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatView];
}

- (void)creatView {
    NSArray *arr1 = @[@"09-07", @"09-08", @"09-10", @"09-11", @"09-12", @"09-13", @"09-14", @"09-15", @"09-16", @"09-17", @"09-18", @"09-19", @"09-20", @"09-21", @"09-22", @"09-23", @"09-24", @"09-25", @"09-26", @"09-27", @"09-28", @"09-29", @"09-30", @"10-07", @"10-08", @"10-10", @"10-11", @"10-12", @"10-13", @"10-14", @"10-15", @"10-16", @"10-17", @"10-18", @"10-19", @"10-20", @"10-21", @"10-22", @"10-23", @"10-24", @"10-25", @"10-26", @"10-27", @"10-28", @"10-29", @"10-30"];
    NSArray *arr2 = @[@"90", @"156.4", @"25.2", @"230.5", @"155.3", @"178", @"188.8", @"150", @"130", @"100.4", @"180.5", @"90.7", @"150.4", @"166.4", @"155.3", @"178", @"180", @"155.3", @"220", @"100.5", @"160.5", @"180.3", @"120.8", @"90", @"110.4", @"190.2", @"230.5", @"125.3", @"138", @"158.8", @"150", @"120", @"100.4", @"190.5", @"110.7", @"110.4", @"176.4", @"155.3", @"178", @"180", @"155.3", @"220", @"100.5", @"180.5", @"180.3", @"130.8"];
    XtayLineChartView *lineChart = [[XtayLineChartView alloc] initWithFrame:CGRectMake(10, 30, XTAY_SCREEN_W-20, 300) horizonAxisArr:arr1 verticalAxisArr:arr2 horUnit:@"日期" verUnit:@"$"];
    lineChart.backgroundColor = [UIColor clearColor];
    lineChart.doesShowGradientLayer = YES;
    [self.view addSubview:lineChart];
}

@end
