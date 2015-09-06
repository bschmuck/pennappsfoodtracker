//
//  FoodCenterViewController.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodCenterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FoodImageViewController.h"
#import "FoodSummaryViewController.h"
#import "FoodHistoryViewController.h"
#import "FoodAboutViewController.h"


@interface FoodCenterViewController ()

@property (strong, nonatomic) UIViewController *childViewController;
@property (weak, nonatomic) IBOutlet UIView *userView;


@end

@implementation FoodCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 37, 25, 23)];
    [self.menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    
    FoodImageViewController *viewController = [[FoodImageViewController alloc] initWithNibName:@"FoodImageViewController" bundle:nil];
    viewController.view.frame = self.view.bounds;
    
    [self.view addSubview:viewController.view];
    
    [self addChildViewController:viewController];
    self.childViewController = viewController;
    
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton.tag = 1;
}

/**
 Dismisses keyboard when editing has completed
 */
- (void)dismissKeyboard{
    [self.view endEditing:YES];
    //[self hideTableLocationsView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 Used to track the state of the left sidebar menu
 */
- (void)showLeftMenu:(id)sender {
    UIButton *toggleMenu = (UIButton *)sender;
    switch(toggleMenu.tag){
        case 0:
            [self.delegate hideMenu];
            break;
        case 1:
            [self.delegate showMenu];
            break;
        default:
            break;
    }
}



/**
 Switches out child view controller depending on which
 item was selected from the menu
 */
- (void)didSelectSubMenu:(NSInteger)submenu{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLeftMenu:nil];
    });
    UIViewController *selectedViewController;
    [self.userView removeFromSuperview];
    [self.childViewController.view removeFromSuperview];
    [self.childViewController removeFromParentViewController];
    switch(submenu){
        case 0:
        {
            selectedViewController = [[FoodImageViewController alloc] initWithNibName:@"FoodImageViewController" bundle:nil];
            break;
        }
        case 1:
        {
            selectedViewController = [[FoodSummaryViewController alloc] initWithNibName:@"FoodSummaryViewController" bundle:nil];
            break;
        }
        case 2:
        {
            selectedViewController = [[FoodHistoryViewController alloc] initWithNibName:@"FoodHistoryViewController" bundle:nil];
            break;
        }
        case 3:
            selectedViewController = [[FoodAboutViewController alloc] initWithNibName:@"FoodAboutViewController" bundle:nil];
            break;
            
        default:
            break;
    }
    self.childViewController = selectedViewController;
    self.childViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1 animations:^{
            [self.view addSubview:selectedViewController.view];
            [self addChildViewController:selectedViewController];
            
            [self.view addSubview:self.menuButton];
        }];
    });
    
}

@end
