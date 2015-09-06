//
//  FoodCalorieCalculator.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodPersonalProfile.h"

typedef NS_ENUM(NSUInteger, ExerciseAmount) {
    ExerciseAmountNoExercise,
    ExerciseAmountLittleExercise,
    ExerciseAmountModerateExercise,
    ExerciseAmountHeavyExercise,
    ExerciseAmountVeryHeavyExercise
};

@interface FoodCalorieCalculator : NSObject

- (double)calculateSuggestedCaloriesWithProfile:(FoodPersonalProfile *)profile andExercise:(ExerciseAmount)exerciseAmount;

@end
