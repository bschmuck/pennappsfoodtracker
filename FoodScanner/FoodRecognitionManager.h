//
//  FoodRecognitionManager.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/4/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FoodRecognitionManager;

@protocol FoodRecognitionManagerDelegate <NSObject>

- (void)FoodRecognitionManager:(FoodRecognitionManager *)manager didRetrieveTags:(NSArray *)tags;

@end

@interface FoodRecognitionManager : NSObject

@property (copy, nonatomic) NSString *accessToken;
@property (weak) id<FoodRecognitionManagerDelegate>delegate;

- (void)initializeSession;
//- (void)getInformationForImage:(NSString *)imageURLString;
- (void)getInformationForImage:(UIImage *)image;

@end
