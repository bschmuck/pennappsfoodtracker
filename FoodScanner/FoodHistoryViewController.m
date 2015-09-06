//
//  FoodHistoryViewController.m
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodHistoryViewController.h"
#import "FoodHistoryData.h"
#import "CustomTableViewCell.h"

@interface FoodHistoryViewController ()

@property(strong, nonatomic) FoodHistoryData *historyData;

@end

@implementation FoodHistoryViewController
@synthesize todayTable;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.historyData = [[FoodHistoryData alloc]init];
    self.historyData.delegate = self;
    self.todayTable = [NSMutableArray array];
    [self.historyData getData];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Called when a dictionary of past food items has been received
 */
-(void) foodHistoryData:(FoodHistoryData *)historyData didReceiveFoodInfo:(NSDictionary *)dict {
    [todayTable addObject:dict];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

/**
 Number of sections in table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

/**
 Number of rows in table view
 Added one for a blank space
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NSLog(@"This has %ld items", self.todayTable.count);
    return self.todayTable.count + 1;
}

/**
 Fills table with data based on past food items
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    
    static NSString *cellId = @"customCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    // Configure the cell...
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.row == 0){
        cell.name.text = @"";
        cell.calories.text = @"";
        cell.time.text = @"";
        return cell;
    }
    else{
        index -= 1;
    }
    
    cell.name.text = [[self.todayTable objectAtIndex:index] objectForKey:@"name"];
    NSDictionary * dict = [self.todayTable objectAtIndex:index];
    NSString *calString = [NSString stringWithFormat:@"%@ cal", [dict objectForKey:@"calories"]];
    cell.calories.text = calString;
    
    NSDate *dateCurrent = [dict objectForKey:@"time"];
    NSLog(@"%@", dateCurrent);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:dateCurrent];
    NSString *finalString = [NSString stringWithFormat:@"At %@", dateString];
    cell.time.text = finalString;
    
    return cell;
}

@end
