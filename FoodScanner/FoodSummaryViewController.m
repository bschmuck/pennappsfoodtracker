//
//  FoodSummaryViewController.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodSummaryViewController.h"
#import "CircleProgressView.h"
#import "FoodHealthkitManager.h"


@interface FoodSummaryViewController ()
@property (weak, nonatomic) IBOutlet CircleProgressView *caloriesProgress;
@property (strong, nonatomic) FoodHealthKitManager *healthkitManager;

@end

@implementation FoodSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.caloriesProgress setProgress:0.75];
    self.healthkitManager = [[FoodHealthKitManager alloc] init];
    [self.healthkitManager requestAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
