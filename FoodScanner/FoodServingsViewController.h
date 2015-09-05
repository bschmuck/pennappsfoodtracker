//
//  FoodServingsViewController.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodServingsViewController;

@protocol FoodServingViewControllerDelegate <NSObject>

- (void)FoodServingViewController:(FoodServingsViewController *)viewController didUpdateServings:(NSInteger)servings;

@end

@interface FoodServingsViewController : UIViewController

@property (weak) id<FoodServingViewControllerDelegate> delegate;

@end
