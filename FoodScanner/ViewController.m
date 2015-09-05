//
//  ViewController.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/4/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "ViewController.h"

#import "FoodRecognitionManager.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)sendRequest:(id)sender {
    FoodRecognitionManager *foodManager = [[FoodRecognitionManager alloc] init];
    [foodManager initializeSession];
    
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"coffee-3" withExtension:@"jpg"];
    NSString *imageURLString = [imageURL absoluteString];
    imageURLString = [imageURLString substringFromIndex:8];
    UIImage *image = [UIImage imageNamed:@"coffee-3.jpg"];
    [foodManager getInformationForImage:image
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
