//
//  FoodRecognitionManager.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/4/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FoodRecognitionManager : NSObject

@property (copy, nonatomic) NSString *accessToken;

- (void)initializeSession;
//- (void)getInformationForImage:(NSString *)imageURLString;
- (void)getInformationForImage:(UIImage *)image;

@end
