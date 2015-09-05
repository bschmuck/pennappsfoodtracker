//
//  FoodCenterViewController.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodLeftMenuViewController.h"

@protocol FoodCenterViewControllerDelegate <NSObject>

- (void)hideMenu;
- (void)showMenu;

@end

@interface FoodCenterViewController : UIViewController <FoodLeftMenuViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (weak) id<FoodCenterViewControllerDelegate>delegate;

@end
