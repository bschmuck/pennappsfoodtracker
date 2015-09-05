//
//  FoodHealthKitManager.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@import HealthKit;

@interface FoodHealthKitManager : NSObject

- (void)requestAuthorization;
- (void)saveCalorieInformationWithCalories:(double)calories;

@end
