//
//  ImageViewController.m
//  CalorieCounter
//
//  Created by Varun Raghav Ramesh on 9/4/15.
//  Copyright © 2015 vrsquare. All rights reserved.
//

#import "FoodImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FoodHealthKitManager.h"
#import "FoodHistoryData.h"
#import "FoodServingsViewController.h"
#import "FoodHistoryData.h"

@interface FoodImageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *foodItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (strong, nonatomic) IBOutlet UIView *numberServingsView;
@property (weak, nonatomic) IBOutlet UILabel *numServingsLabel;

@property (strong, nonatomic) FoodRecognitionManager *manager;
@property (strong, nonatomic) FoodTagLookupManager *lookupManager;

@property (strong, nonatomic) UITableView *foodTableView;
@property (assign, nonatomic) NSInteger numServings;
@property (strong, nonatomic) NSString *selectedFoodItem;

@property (strong, nonatomic) FoodHealthKitManager *healthKitManager;
@property (strong, nonatomic) FoodHistoryData *historyDataManager;

@property (strong, nonatomic) FoodServingsViewController *servingsViewController;

@end

@implementation FoodImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FoodHistoryData checkNewDay:NO];
    
    self.numServings = 1;
    self.numberServingsView.layer.cornerRadius = 5;
    self.manager = [[FoodRecognitionManager alloc] init];
    self.lookupManager = [[FoodTagLookupManager alloc] init];
    self.manager.delegate = self.lookupManager;
    self.lookupManager.delegate = self;
    self.healthKitManager = [[FoodHealthKitManager alloc] init];
    [self.healthKitManager requestAuthorization];
    self.historyDataManager = [[FoodHistoryData alloc] init];
    [self.menuButton addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.numberServingsView = [[UIView alloc] initWithFrame:CGRectMake(73, 249, 240, 167)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Open image picker and displays camera view
 */
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

/**
 Called once image has been taken with image picker controller
 */
- (void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    if(self.foodTableView){
        [self.foodTableView removeFromSuperview];
    }
    
    UIImage *foodImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = foodImage;
    
    //Retrieves information for a given image from Clarifai
    [self.manager initializeSession];
    [self.manager getInformationForImage:foodImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 Called if image picker controller was canceled by user
 */
- (void)imagePickerControllerDidCancel:(nonnull UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 Called once food item tags have been received
 */
- (void)FoodTagLookupManager:(FoodTagLookupManager *)lookupManager didReceiveItemPossibilities:(NSDictionary *)items{
    self.foodPossibilitiesDict = items;
    self.foodItemNames = [self.foodPossibilitiesDict allKeys];
    self.foodTableView = [[UITableView alloc] initWithFrame:self.imageView.frame style:UITableViewStylePlain];
    [self.foodTableView setBackgroundColor:[UIColor darkGrayColor]];
    [self.foodTableView setSeparatorColor:[UIColor yellowColor]];
    self.foodTableView.delegate = self;
    self.foodTableView.dataSource = self;
    [self.view addSubview:self.foodTableView];
}

/**
 Returns the number of rows in the food item name table view
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.foodItemNames count];
}

/**
 Populates table view with selectable food items corresponding
 to given item
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"foodCell"];
    }
    [cell setBackgroundColor:[UIColor darkGrayColor]];
    [cell.textLabel setTextColor:[UIColor yellowColor]];
    NSString *key = [self.foodItemNames objectAtIndex:indexPath.row];
    [cell.textLabel setText:key];
    return cell;
}

/**
 Updates UI once item has been selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedFoodItem = [self.foodItemNames objectAtIndex:indexPath.row];
    NSNumber *calories = self.foodPossibilitiesDict[selectedFoodItem];
    self.numServings = 1;
    self.selectedFoodItem = selectedFoodItem;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.foodItemLabel setText:selectedFoodItem];
        [self.caloriesLabel setText:[NSString stringWithFormat:@"%@ Calories", calories]];
        [self.foodTableView removeFromSuperview];
        self.servingsViewController = [[FoodServingsViewController alloc] initWithNibName:@"FoodServingsViewController" bundle:nil];
        self.servingsViewController.delegate = self;
        [self presentViewController:self.servingsViewController animated:YES completion:nil];
       // [self.numberServingsView setHidden:NO];
        
       // [self.view addSubview:self.numberServingsView];
    });
}

/**
 Increments number of servings selected
 */
- (IBAction)addServing:(id)sender {
    self.numServings++;
    [self.caloriesLabel setText:[NSString stringWithFormat:@"%ld Calories",([[self.foodPossibilitiesDict objectForKey:self.selectedFoodItem]integerValue] * self.numServings)]];
    [self.numServingsLabel setText:[NSString stringWithFormat:@"%ld", self.numServings]];
}

/**
 Decrements number of servings selected
 */
- (IBAction)removeServing:(id)sender {
    if(self.numServings > 0){
        self.numServings--;
    }
      [self.caloriesLabel setText:[NSString stringWithFormat:@"%ld Calories",([[self.foodPossibilitiesDict objectForKey:self.selectedFoodItem]integerValue] * self.numServings)]];
    [self.numServingsLabel setText:[NSString stringWithFormat:@"%ld", self.numServings]];

}

- (IBAction)cancelAddItem:(id)sender {
    [self.numberServingsView setHidden:YES];
}

/**
 Hides the servings view
 */
- (IBAction)dismissServingsView:(id)sender {
    [self.numberServingsView setHidden:YES];
    float numCalories = self.numServings * [[self.foodPossibilitiesDict objectForKey:self.selectedFoodItem] floatValue];
    [self.healthKitManager saveCalorieInformationWithCalories:numCalories];
    [self.historyDataManager saveData:self.selectedFoodItem withCalories:([self.foodPossibilitiesDict[self.selectedFoodItem] doubleValue] * self.numServings)];
    FoodServingsViewController *viewController = [[FoodServingsViewController alloc] initWithNibName:@"FoodServingsViewController" bundle:nil];
    viewController.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:viewController animated:YES completion:nil];
    });
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
 Called when servings have been updated. Information is then 
 saved in HealthKit
 */
- (void)FoodServingViewController:(FoodServingsViewController *)viewController didUpdateServings:(NSInteger)servings{
    self.numServings = servings;
    [self.caloriesLabel setText:[NSString stringWithFormat:@"%ld Calories",([[self.foodPossibilitiesDict objectForKey:self.selectedFoodItem]integerValue] * self.numServings)]];
    [self.numServingsLabel setText:[NSString stringWithFormat:@"%ld", self.numServings]];
    float numCalories = self.numServings * [[self.foodPossibilitiesDict objectForKey:self.selectedFoodItem] floatValue];
    [self.healthKitManager saveCalorieInformationWithCalories:numCalories];
    [self.historyDataManager saveData:self.selectedFoodItem withCalories:([self.foodPossibilitiesDict[self.selectedFoodItem] doubleValue] * self.numServings)];
}

@end
