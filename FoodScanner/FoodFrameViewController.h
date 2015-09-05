//
//  FoodFrameViewController.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FoodLeftMenuViewController.h"
#import "FoodCenterViewController.h"


@interface FoodFrameViewController : UIViewController <FoodLeftMenuViewControllerDelegate, FoodCenterViewControllerDelegate>
@end
