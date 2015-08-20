//
//  ViewController.m
//  FitWatch
//
//  Created by Jason Terhorst on 8/20/15.
//  Copyright © 2015 Jason Terhorst. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (nonatomic, strong) CMPedometer * pedometer;
@property (nonatomic, assign) NSInteger stepCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([CMPedometer isStepCountingAvailable]) {
        NSLog(@"step counter ready!");
        _pedometer = [[CMPedometer alloc] init];
        NSDate * startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
        [_pedometer startPedometerUpdatesFromDate:startOfToday withHandler:^(CMPedometerData * data, NSError * error) {
            _stepCount = _stepCount + [[data numberOfSteps] integerValue];
            NSNumberFormatter * outputFormatter = [[NSNumberFormatter alloc] init];
            outputFormatter.usesGroupingSeparator = YES;
            outputFormatter.groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
            outputFormatter.groupingSize = 3;
            outputFormatter.zeroSymbol = @"--";
            _stepOutputLabel.text = [outputFormatter stringFromNumber:@(_stepCount)];
        }];
    } else {
        NSLog(@"can't get step counts");
        _stepOutputLabel.text = @"--";
    }
}

- (void)dealloc
{
    [_pedometer stopPedometerUpdates];
    _pedometer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
