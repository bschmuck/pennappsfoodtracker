//
//  FoodLoginViewController.h
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *logIn;

- (IBAction)createNewAccount:(id)sender;
- (IBAction)logInMethod:(id)sender;
- (IBAction)removeKeyboard:(id)sender;

@end
