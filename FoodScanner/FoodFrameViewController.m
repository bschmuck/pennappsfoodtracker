//
//  FoodFrameViewController.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodFrameViewController.h"
#import "FoodCenterViewController.h"
#import <QuartzCore/QuartzCore.h>

#define LEFT_TAG 1
#define MAIN_TAG 2

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 40

@interface FoodFrameViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) FoodCenterViewController *mainViewController;
@property (strong, nonatomic) FoodLeftMenuViewController *leftMenuViewController;

@property (assign, nonatomic) BOOL leftMenuIsShowing;
@property (assign, nonatomic) BOOL showPanel;
@property (assign, nonatomic) CGPoint prevVelocity;

@end


@implementation FoodFrameViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupMainView];
    [self setupGestures];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Used to track the state of the left sidebar menu
 */
- (IBAction)showLeftMenu:(id)sender {
    UIButton *toggleMenu = (UIButton *)sender;
    switch(toggleMenu.tag){
        case 0:
            [self hideMenu];
            break;
        case 1:
            [self showMenu];
            break;
        default:
            break;
    }
}

/**
 Adds the main user view to the container view controller
 */
- (void)setupMainView {
    self.mainViewController = [[FoodCenterViewController alloc] initWithNibName:@"FoodCenterViewController" bundle:nil];
    self.mainViewController.view.tag = MAIN_TAG;
    self.mainViewController.delegate = self;
    [self.view addSubview:self.mainViewController.view];
    self.mainViewController.menuButton.tag = 0;
    [self showLeftMenu:self.mainViewController.menuButton];
    [self addChildViewController:self.mainViewController];
    [self.mainViewController didMoveToParentViewController:self];
}

/**
 Used to track pan gestures, allows user to pull menu to open
 */
- (void)moveMenu:(id)sender{
    UITapGestureRecognizer *gestureRecognizer = (UITapGestureRecognizer *)sender;
    [gestureRecognizer.view.layer removeAllAnimations];
    
    UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)sender;
    CGPoint translatedPoint = [panRecognizer translationInView:self.view];
    CGPoint velocity = [panRecognizer velocityInView:self.view];
    
    //Velocity must be negative to open left view
    if(panRecognizer.state == UIGestureRecognizerStateBegan){
        UIView *menuView = nil;
        if(velocity.x < 0){
            menuView = [self getMenuView];
        }
        [self.view sendSubviewToBack:menuView];
        [[sender view] bringSubviewToFront:panRecognizer.view];
    }
    
    //If velocity was high enough, open/close menu
    if(panRecognizer.state == UIGestureRecognizerStateEnded){
        if(!self.showPanel){
            [self hideMenu];
        }
        else{
            [self showMenu];
        }
    }
    
    //Tracks distance swiped to determine if it is a valid open/close menu
    if(panRecognizer.state == UIGestureRecognizerStateChanged){
        self.showPanel = abs([sender view].center.x - self.mainViewController.view.frame.size.width/2) > self.mainViewController.view.frame.size.width/2;
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [panRecognizer setTranslation:CGPointMake(0,0) inView:self.view];
        self.prevVelocity = velocity;
    }
}

/**
 Sets up the view controler to track pan gestures
 */
- (void)setupGestures{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveMenu:)];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.mainViewController.view addGestureRecognizer:panRecognizer];
}

/**
 Resets the main view after menu has been closed
 */
- (void)resetMainView {
    if(self.leftMenuViewController != nil){
        self.mainViewController.menuButton.tag = 1;
        self.leftMenuIsShowing = NO;
    }
}

/**
 Animates and hides the left side menu
 */
- (void)hideMenu{
    [UIView animateWithDuration:SLIDE_TIMING animations:^{
        self.mainViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        if (finished) {
            [self resetMainView];
        }
    }];
}

/**
 Initializes and retrieves the left menu view
 */
- (UIView *)getMenuView{
    if(self.leftMenuViewController == nil){
        self.leftMenuViewController = [[FoodLeftMenuViewController alloc] initWithNibName:@"FoodLeftMenuViewController" bundle:nil];
        self.leftMenuViewController.delegate = self.mainViewController;

        
        self.leftMenuViewController.view.tag = LEFT_TAG;
        [self.leftMenuViewController updateTableView];
        
        
        [self.view addSubview:self.leftMenuViewController.view];
        [self addChildViewController:self.leftMenuViewController];
        [self.leftMenuViewController didMoveToParentViewController:self];
        self.leftMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.leftMenuIsShowing = YES;
    [self showCenterViewWithShadow:YES withOffset:-2];
    return self.leftMenuViewController.view;
}

/**
 Displays shadow on the main view when menu is opened
 */
- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [self.mainViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [self.mainViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mainViewController.view.layer setShadowOpacity:0.8];
        [self.mainViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [self.mainViewController.view.layer setCornerRadius:0.0f];
        [self.mainViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

/**
 Animates and displays left menu
 */
- (void)showMenu {
    UIView *menuView = [self getMenuView];
    [self.view sendSubviewToBack:menuView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainViewController.view.frame = CGRectMake(self.view.frame.size.width * (2/3.), 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    completion:^(BOOL finished) {
         if(finished){
             self.mainViewController.menuButton.tag = 0;
         }
     }];
}

/**
 Loads main view controller
 */
- (void)loadViewController:(UIViewController *)viewController{
    [self.mainViewController.view removeFromSuperview];
    [self.mainViewController removeFromParentViewController];
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
}

@end
