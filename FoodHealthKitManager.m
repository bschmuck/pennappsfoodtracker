//
//  FoodHealthKitManager.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodHealthKitManager.h"

@interface FoodHealthKitManager()

@property (strong, nonatomic) HKHealthStore *healthStore;

@end

@implementation FoodHealthKitManager

- (id)init{
    self = [super init];
    self.healthStore = [[HKHealthStore alloc] init];
    return self;
}

/**
 Request authorization to read and write user's calories
 */
- (void)requestAuthorization{
    if([HKHealthStore isHealthDataAvailable]){
        HKQuantityType *caloriesConsumed = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
        NSSet *permissions = [NSSet setWithObjects:caloriesConsumed, nil];
        
        [self.healthStore requestAuthorizationToShareTypes:permissions readTypes:permissions completion:nil];
    }
}

/**
 Save calorie information to Health
 */
- (void)saveCalorieInformationWithCalories:(double)calories{
    calories *= 1000;
    HKUnit *unit = [HKUnit calorieUnit];
    HKQuantity *calorieQuantity = [HKQuantity quantityWithUnit:unit doubleValue:calories];
    
    NSDate *now = [NSDate date];
    
    HKQuantityType *calorieQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    
    HKQuantitySample *calorieSample = [HKQuantitySample quantitySampleWithType:calorieQuantityType quantity:calorieQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:calorieSample withCompletion:^(BOOL success, NSError *error) {
        
    }];

}

@end
