//
//  FoodHistoryViewController.h
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodHistoryData.h"

@interface FoodHistoryViewController : UITableViewController <FoodHistoryDataDelegate>

@property NSMutableArray *todayTable;

@end
