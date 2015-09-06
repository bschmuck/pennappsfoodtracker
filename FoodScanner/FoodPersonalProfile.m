//
//  FoodPersonalProfile.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodPersonalProfile.h"

@interface FoodPersonalProfile()

@property (strong, nonatomic) FoodHealthKitManager *manager;

@end

@implementation FoodPersonalProfile

- (id)init{
    self = [super init];
    self.manager = [[FoodHealthKitManager alloc] init];
    self.manager.delegate = self;

    return self;
}

- (void)pullProfileInformation{
    [self.manager retrieveWeight];
    [self.manager retrieveHeight];
    self.age = [self.manager getAge];
    self.isMale = [self.manager retrieveBiologicalSexIsMale];
}

- (void)FoodHealthKitManager:(FoodHealthKitManager *)manager didReceiveHeight:(double)height{
    self.height = height;
    if(self.weight){
        [self.delegate FoodPersonalProfileReadyForCalculation:self];
    }
}

- (void)FoodHealthKitManager:(FoodHealthKitManager *)manager didReceiveWeight:(double)weight{
    self.weight = weight;
    if(self.height){
        [self.delegate FoodPersonalProfileReadyForCalculation:self];
    }
}

@end