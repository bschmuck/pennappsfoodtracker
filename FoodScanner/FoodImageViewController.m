//
//  ImageViewController.m
//  CalorieCounter
//
//  Created by Varun Raghav Ramesh on 9/4/15.
//  Copyright © 2015 vrsquare. All rights reserved.
//

#import "FoodImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FoodImageViewController ()

@property (strong, nonatomic) FoodRecognitionManager *manager;

@end

@implementation FoodImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[FoodRecognitionManager alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

-(void) imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    UIImage *img = info[UIImagePickerControllerEditedImage];
    self.imageView.image = img;
    
    [self.manager initializeSession];
    [self.manager setDelegate:self];
    [self.manager getInformationForImage:img];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) imagePickerControllerDidCancel:(nonnull UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)FoodRecognitionManager:(FoodRecognitionManager *)manager didRetrieveTags:(NSArray *)tags{
    __block NSInteger xDistance = 20;
    __block NSInteger yDistance = 144;
    __block NSInteger tagIndex = 0;

    for(NSString *tag in tags){
        if([tag isKindOfClass:[NSString class]] && tagIndex < 10){
       
       /* dispatch_async(dispatch_get_main_queue(), ^{
            UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDistance, yDistance, 100, 20)];
            [tagLabel setText:tag];
            [tagLabel setBackgroundColor:[UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f]];
            [tagLabel setTextColor:[UIColor whiteColor]];
            tagLabel.layer.cornerRadius = 5.0f;
            tagLabel.layer.masksToBounds = YES;
            [self.view addSubview:tagLabel];
            yDistance += 40;
            tagIndex++;
        });*/
    }
    }
}

@end
