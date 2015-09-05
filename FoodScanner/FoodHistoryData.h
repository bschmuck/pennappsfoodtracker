//
//  FoodHistoryData.h
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FoodHistoryData;

@protocol FoodHistoryDataDelegate <NSObject>

-(void) foodHistoryData :(FoodHistoryData *) historyData didReceiveFoodInfo:(NSDictionary *)dict;

@end

@interface FoodHistoryData : NSObject

@property(weak, nonatomic) id <FoodHistoryDataDelegate> delegate;

-(void) saveData:(NSString*)name withCalories:(double)calories;
-(void) getData;

@end
