//
//  ImageViewController.m
//  CalorieCounter
//
//  Created by Varun Raghav Ramesh on 9/4/15.
//  Copyright © 2015 vrsquare. All rights reserved.
//

#import "FoodImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

-(void) imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    UIImage *img = info[UIImagePickerControllerEditedImage];
    self.imageView.frame= CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, img.size.width, img.size.height);
    self.imageView.image = img;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) imagePickerControllerDidCancel:(nonnull UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



@end
