//
//  InterfaceController.m
//  FitWatch WatchKit Extension
//
//  Created by Jason Terhorst on 8/20/15.
//  Copyright © 2015 Jason Terhorst. All rights reserved.
//

#import "InterfaceController.h"
@import CoreMotion;

@interface InterfaceController()
@property (nonatomic, strong) CMPedometer * pedometer;
@property (nonatomic, assign) NSInteger stepCount;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
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

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [_pedometer stopPedometerUpdates];
    _pedometer = nil;
}

@end



