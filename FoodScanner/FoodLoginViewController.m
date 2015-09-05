//
//  FoodLoginViewController.m
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodLoginViewController.h"
#import "FoodSignUpViewController.h"
#import "FoodImageViewController.h"
#import <Parse/Parse.h>


@interface FoodLoginViewController ()

@end

@implementation FoodLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    if ([PFUser currentUser]) {
        NSLog(@"%@", [PFUser currentUser].username);
        FoodImageViewController *imgVC = [[FoodImageViewController alloc] initWithNibName:@"FoodImageViewController" bundle:nil];
        [self presentViewController:imgVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Launches sign-up view controller
 */
- (IBAction)createNewAccount:(id)sender {
    FoodSignUpViewController * signUpVC = [[FoodSignUpViewController alloc] initWithNibName:@"FoodSignUpViewController" bundle:nil];
    [self presentViewController:signUpVC animated:YES completion:nil];
}

/**
 Logs user in with username and password
 */
- (IBAction)logInMethod:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.email.text password:self.password.text block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            FoodImageViewController *imageVC = [[FoodImageViewController alloc] initWithNibName:@"FoodImageViewController" bundle:nil];
            [self presentViewController:imageVC animated:YES completion:nil];
        } else {
            // The login failed. Check error to see why.
            printf("Error");
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Error with login" message:@"Enter the correct login credentials" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
}

/**
 Hides keyboard after return key pressed
 */
- (IBAction)removeKeyboard:(id)sender {
    [sender resignFirstResponder];
}
@end
