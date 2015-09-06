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
        HKQuantityType *height = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
        HKQuantityType *weight = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
        HKCharacteristicType *biologicalSex = [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
        HKCharacteristicType *birthday = [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
        
        NSSet *readPermissions = [NSSet setWithObjects:caloriesConsumed, activeCalories, height, weight, biologicalSex, birthday, nil];
        NSSet *writePermissions = [NSSet setWithObjects:caloriesConsumed, nil];
        
        [self.healthStore requestAuthorizationToShareTypes:writePermissions readTypes:readPermissions completion:nil];
    }
}

/**
 Retrieves height from HealthKit
 */
- (void)retrieveHeight{
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:heightType predicate:nil limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HKQuantitySample *quantitySample = results.firstObject;
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit inchUnit];
                double userHeight = [quantity doubleValueForUnit:heightUnit];
                [self.delegate FoodHealthKitManager:self didReceiveHeight:userHeight];
            });
    }];
    [self.healthStore executeQuery:query];
}

/**
 Retrieves weight from HealthKit: Note, issue was occuring with
 HealthKit for this parameterm, so hardcoded value being
 temporarily used
 */
- (void)retrieveWeight{
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:weightType predicate:nil limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if(results){
            dispatch_async(dispatch_get_main_queue(), ^{
                HKQuantitySample *quantitySample = results.firstObject;
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *weightUnit = [HKUnit poundUnit];
                double userWeight = [quantity doubleValueForUnit:weightUnit];
                [self.delegate FoodHealthKitManager:self didReceiveWeight:userWeight];
            });
        }
    }];
    [self.healthStore executeQuery:query];
    [self.delegate FoodHealthKitManager:self didReceiveWeight:170];
}

/**
 Determines whether gender is male or female based on HealthKit data
 */
- (BOOL)retrieveBiologicalSexIsMale{
    HKBiologicalSexObject *biologicalSex = [self.healthStore biologicalSexWithError:nil];
    switch (biologicalSex.biologicalSex) {
        case HKBiologicalSexFemale:
            return NO;
        case HKBiologicalSexMale:
            return YES;
        default:
            break;
    }
    return NO;
}

/**
 Returns age in years based on HealthKit data
 */
- (NSInteger)getAge{
    NSDate *birthday = [self.healthStore dateOfBirthWithError:nil];
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:birthday toDate:today options:0];
    return components.year;
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

/**
 Returns active calories for day based on HealthKit
 */
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
