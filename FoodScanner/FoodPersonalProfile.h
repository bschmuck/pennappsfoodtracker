//
//  FoodPersonalProfile.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodHealthKitManager.h"

@class FoodPersonalProfile;

@protocol FoodPersonalProfileDelegate <NSObject>

- (void)FoodPersonalProfileReadyForCalculation:(FoodPersonalProfile *)profile;

@end

@interface FoodPersonalProfile : NSObject <FoodHealthKitManagerDelegate>

@property (assign, nonatomic) BOOL isMale;
@property (assign, nonatomic) float weight;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) float age;
@property (weak) id<FoodPersonalProfileDelegate>delegate;
- (void)pullProfileInformation;

@end
