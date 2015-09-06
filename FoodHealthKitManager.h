//
//  FoodHealthKitManager.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FoodHealthKitManager;

@protocol FoodHealthKitManagerDelegate <NSObject>

- (void)FoodHealthKitManager:(FoodHealthKitManager *)manager didReceiveHeight:(double)height;
- (void)FoodHealthKitManager:(FoodHealthKitManager *)manager didReceiveWeight:(double)weight;

@end

@import HealthKit;

@interface FoodHealthKitManager : NSObject

- (void)requestAuthorization;
- (void)saveCalorieInformationWithCalories:(double)calories;
- (void)getActiveCaloriesBurnedToday;

- (NSInteger)getAge;
- (BOOL)retrieveBiologicalSexIsMale;
- (void)retrieveWeight;
- (void)retrieveHeight;

@property (weak) id<FoodHealthKitManagerDelegate> delegate;


@end
