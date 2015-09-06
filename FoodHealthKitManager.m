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
        HKQuantityType *activeCalories = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
        
        NSSet *readPermissions = [NSSet setWithObjects:caloriesConsumed, activeCalories, nil];
        NSSet *writePermissions = [NSSet setWithObjects:caloriesConsumed, nil];
        
        [self.healthStore requestAuthorizationToShareTypes:writePermissions readTypes:readPermissions completion:nil];
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

- (void)getActiveCaloriesBurnedToday{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    HKCorrelationType *activeCaloriesType = [HKObjectType correlationTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:activeCaloriesType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        NSLog(@"%@", results);
    }];
    [self.healthStore executeQuery:query];
}

@end
