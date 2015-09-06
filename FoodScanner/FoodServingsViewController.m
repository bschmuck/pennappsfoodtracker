//
//  FoodServingsViewController.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodServingsViewController.h"

@interface FoodServingsViewController ()

@property (assign, nonatomic) NSInteger numServings;
@property (weak, nonatomic) IBOutlet UILabel *numServingsLabel;

@end

@implementation FoodServingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numServings = 1;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Increments number of servings selected
 */
- (IBAction)addServing:(id)sender {
    self.numServings++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.numServingsLabel setText:[NSString stringWithFormat:@"%ld", self.numServings]];
    });
}
/**
 Decrements number of servings selected
 */
- (IBAction)removeServing:(id)sender {
    if(self.numServings > 0){
        self.numServings--;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.numServingsLabel setText:[NSString stringWithFormat:@"%ld", self.numServings]];
    });
}

/**
 Cancels adding an item
 */
- (IBAction)cancelAddItem:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

/**
 Saves serving update and dismisses view
 */
- (IBAction)saveServings:(id)sender {
    [self.delegate FoodServingViewController:self didUpdateServings:self.numServings];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });}

@end
