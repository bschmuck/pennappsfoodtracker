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
#import "FoodCalorieCalculator.h"
#import "FoodHistoryData.h"
#import <Parse/Parse.h>


@interface FoodSummaryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *remainingCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (weak, nonatomic) IBOutlet CircleProgressView *caloriesProgress;
@property (strong, nonatomic) FoodHealthKitManager *healthkitManager;
@property (strong, nonatomic) FoodPersonalProfile *profile;
@property (assign, nonatomic) NSInteger calorieSuggestion;
@property (weak, nonatomic) IBOutlet UILabel *dailyIntakeLabel;
@property (assign, nonatomic) double consumedCalories;
@property (strong, nonatomic) FoodHistoryData *historyData;

@end

@implementation FoodSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthkitManager = [[FoodHealthKitManager alloc] init];
    [self.healthkitManager requestAuthorization];
    self.profile = [[FoodPersonalProfile alloc] init];
    self.profile.delegate = self;
    [self.profile pullProfileInformation];
    self.historyData = [[FoodHistoryData alloc] init];
    PFUser *user = [PFUser currentUser];
    self.consumedCalories = [[user objectForKey:@"consumed"] doubleValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Called when HealthKit data has been retrieved
 Calorie suggestion is then calculated and UI is updated
 */
- (void)FoodPersonalProfileReadyForCalculation:(FoodPersonalProfile *)profile{
    FoodCalorieCalculator *calculator = [[FoodCalorieCalculator alloc] init];
    self.calorieSuggestion = [calculator calculateSuggestedCaloriesWithProfile:profile andExercise:ExerciseAmountModerateExercise];
  
    NSInteger remainingCalories = self.calorieSuggestion - self.consumedCalories;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dailyIntakeLabel setText:[NSString stringWithFormat:@"Suggested Daily Intake: %ld Calories", self.calorieSuggestion]];
        [self.remainingCaloriesLabel setText:[NSString stringWithFormat:@"%ld calories remaining for today.", remainingCalories]];
        float percentCalories = (float)self.consumedCalories/self.calorieSuggestion;
        if(percentCalories > 1){
            [self.caloriesProgress setTrackFillColor:[UIColor redColor]];
            [self.caloriesProgress setTrackBackgroundColor:[UIColor yellowColor]];
        }
        [self.caloriesProgress setProgress:percentCalories];
        NSInteger percentInt = percentCalories * 100;
        [self.percentLabel setText:[NSString stringWithFormat:@"%ld%%", percentInt]];
        
    });

}


@end
