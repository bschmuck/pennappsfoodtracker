//
//  FoodCalorieCalculator.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodCalorieCalculator.h"
#import <Parse/Parse.h>

@implementation FoodCalorieCalculator

/**
 Calculates suggested calorie intake based on
 Harris-Benedict BMR
 */
- (double)calculateSuggestedCaloriesWithProfile:(FoodPersonalProfile *)profile andExercise:(ExerciseAmount)exerciseAmount{
    float BMR = 0;
    if(profile.isMale){
        BMR = 66 + (6.2 * profile.weight) + (12.7 * profile.height) - (6.76 * profile.age);
    }
    else{
        BMR = 65.5 + (4.35 * profile.weight) + (4.7 * profile.height) - (4.7 * profile.age);
    }
    
    double dailyIntakeCalories = 0;
    
    switch(exerciseAmount){
        case ExerciseAmountNoExercise:
            dailyIntakeCalories = BMR * 1.2;
            break;
        case ExerciseAmountLittleExercise:dailyIntakeCalories = BMR * 1.375;
            break;
        case ExerciseAmountModerateExercise:
            dailyIntakeCalories = BMR * 1.55;
            break;
        case ExerciseAmountHeavyExercise:
            dailyIntakeCalories = BMR * 1.725;
            break;
        case ExerciseAmountVeryHeavyExercise:
            dailyIntakeCalories = BMR * 1.9;
            break;
        default:
            break;
    }
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"goal"] = @(dailyIntakeCalories);
    [currentUser saveInBackground];
    return dailyIntakeCalories;
}



@end
