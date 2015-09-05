//
//  ImageViewController.h
//  CalorieCounter
//
//  Created by Varun Raghav Ramesh on 9/4/15.
//  Copyright © 2015 vrsquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodRecognitionManager.h"


@interface FoodImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FoodRecognitionManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(id)sender;

@end
