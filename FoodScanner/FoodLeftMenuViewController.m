//
//  FoodLeftMenuViewController.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodLeftMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FoodLeftMenuViewController()

@end

@implementation FoodLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    //The options that will shop up on the menu
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self.menuTableView setBackgroundColor:[UIColor darkGrayColor]];
    [self.menuTableView setSeparatorColor:[UIColor yellowColor]];
}

/**
 Updates the table view with all available menu options
 */
- (void)updateTableView{
    self.menuOptions = @[@"Home", @"Today", @"History", @"About"];
}

/**
 Height of table cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

/**
 Carry out actions when a specific menu item is
 selected from the menu view
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    [self.delegate didSelectSubMenu:index];
}

/**
 Fills the left sidebar with options for user
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    UIImageView *iconView = [[UIImageView alloc] init];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] init];
    }
    [cell setBackgroundColor:[UIColor darkGrayColor]];

    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, cell.frame.size.height/2 - 10, 120, 30)];
    
    NSString *menuOption = [self.menuOptions objectAtIndex:indexPath.row];
    
    cellLabel.font = [UIFont fontWithName:@"Avenir Next" size:20];
    cellLabel.text = menuOption;
    
    [cellLabel setBackgroundColor:[UIColor darkGrayColor]];
    
    [cellLabel setTextColor:[UIColor yellowColor]];
   
    [cell.contentView addSubview:cellLabel];
    [cell.contentView addSubview:iconView];
    return cell;
}

/**
 Returns the number of rows in the table view
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.menuOptions count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
