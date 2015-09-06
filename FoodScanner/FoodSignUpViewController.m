//
//  FoodSignUpViewController.m
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodSignUpViewController.h"
#import <Parse/Parse.h>
#import "FoodImageViewController.h"

@interface FoodSignUpViewController ()

@end

@implementation FoodSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Processes user sign up information
 */
- (IBAction)signUp:(id)sender {
    
    if ([self.email.text isEqual: @""]) {
        printf("Email is empty");
        [self showAlert:@"Email is empty" withMessage:@"Please eneter a valid email"];

    } else if ([self.password.text isEqual: @""]) {
        printf("Password is empty");
        [self showAlert:@"Password is empty" withMessage:@"Please enter a valid password"];
        
    } else if ([self.fName.text isEqual:@""]) {
        printf("First Name is empty");
        [self showAlert:@"First name is empty" withMessage:@"Please enter a valid first name"];
    
    } else if ([self.lastName.text isEqual:@""]) {
        printf("Last Name is empty");
        [self showAlert:@"Last name is empty" withMessage:@"Please enter a valid last name"];
        
    } else {
        PFUser *user = [PFUser user];
        user.email = self.email.text;
        user.password = self.password.text;
        user.username = self.email.text;
        user[@"firstname"] = self.fName.text;
        user[@"lastname"] = self.lastName.text;
        user[@"consumed"] = @0.0;
        user[@"goal"] = @2000.0;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self showAlert:@"SignUp is successful" withMessage:@"SignUp is succesful. Click ok to login."];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                printf("Error with signing up");
                [self showAlert:@"Error with signing up" withMessage: errorString];
            }
        }];
    }
}

/**
 Hides keyboard when return key pressed
 */
- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}

/**
 Displays an alert with a given message
 */
- (void)showAlert:(NSString*)title withMessage: (NSString*)message {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action;
    if ([title isEqualToString:@"SignUp is successful"]) {
        action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            FoodImageViewController *imageVC = [[FoodImageViewController alloc] initWithNibName:@"FoodImageViewController" bundle:nil];
            [self presentViewController:imageVC animated:YES completion:nil];
        }];
        
    } else {
        action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    }
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
