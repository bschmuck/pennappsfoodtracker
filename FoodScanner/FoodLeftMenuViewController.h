//
//  FoodLeftMenuViewController.h
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodLeftMenuViewController;

@protocol FoodLeftMenuViewControllerDelegate <NSObject>

- (void)loadViewController:(UIViewController *)viewController;
- (void)didSelectSubMenu:(NSInteger)submenu;

@end

typedef NS_ENUM(NSUInteger, SdrMenuOptions) {
    FoodHome = 0,
    FoodDetails = 1,
    FoodAbout = 2
};

@interface FoodLeftMenuViewController: UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property id<FoodLeftMenuViewControllerDelegate>delegate;
@property (strong, nonatomic) NSArray *menuOptions;

- (void)updateTableView;

@end
