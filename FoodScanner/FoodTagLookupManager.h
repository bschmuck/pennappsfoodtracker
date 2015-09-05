//
//  FoodTagLookupManager.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodRecognitionManager.h"

@class FoodTagLookupManager;

@protocol FoodTagLookupManagerDelegate <NSObject>

- (void)FoodTagLookupManager:(FoodTagLookupManager *)lookupManager didReceiveItemPossibilities:(NSDictionary *)items;

@end

@interface FoodTagLookupManager : NSObject <FoodRecognitionManagerDelegate>

@property (strong, nonatomic) NSArray *filterKeys;
@property (weak) id<FoodTagLookupManagerDelegate>delegate;

@end
