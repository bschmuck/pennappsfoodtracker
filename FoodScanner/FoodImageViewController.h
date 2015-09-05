//
//  ImageViewController.h
//  CalorieCounter
//
//  Created by Varun Raghav Ramesh on 9/4/15.
//  Copyright © 2015 vrsquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodRecognitionManager.h"
#import "FoodTagLookupManager.h"
#import "FoodServingsViewController.h"


@protocol FoodImageViewControllerDelegate <NSObject>

- (void)hideMenu;
- (void)showMenu;

@end


@interface FoodImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FoodTagLookupManagerDelegate, UITableViewDataSource, UITableViewDelegate, FoodServingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary *foodPossibilitiesDict;
@property (strong, nonatomic) NSArray *foodItemNames;
@property (weak) id<FoodImageViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)takePhoto:(id)sender;

@end
