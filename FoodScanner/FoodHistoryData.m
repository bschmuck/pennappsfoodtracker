//
//  FoodHistoryData.m
//  FoodScanner
//
//  Created by Varun Raghav Ramesh on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodHistoryData.h"
#import <Parse/Parse.h>


@implementation FoodHistoryData

- (void)saveData:(NSString *)name withCalories:(double)calories {
    NSDate *date = [NSDate date];
    PFObject *object = [PFObject objectWithClassName:@"History"];
    //object[@"username"] = [PFUser currentUser].username;
    object[@"Name"] = name;
    object[@"Calories"] = @(calories);
    object[@"timeStamp"] = date;
    [object saveInBackground];
    
    PFUser *user = [PFUser currentUser];
    double consumed = [user[@"consumed"] doubleValue];
    consumed += calories;
    user[@"consumed"] = @(consumed);
    [user saveInBackground];
}

- (void)getData {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    PFQuery *query = [PFQuery queryWithClassName:@"History"];
    //[query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"timeStamp" greaterThanOrEqualTo:startDate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld scores.", objects.count);
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[object objectForKey:@"Name"] forKey:@"name"];
                [dict setObject:[object objectForKey:@"Calories"] forKey:@"calories"];
                [dict setObject:[object objectForKey:@"timeStamp"] forKey:@"time"];
                [self.delegate foodHistoryData:self didReceiveFoodInfo:dict];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    
    }];
    
}

+ (void)checkNewDay:(BOOL)forceReset{
    PFUser *user = [PFUser currentUser];
    if(user != nil){
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        NSDate *currentDate = user.updatedAt;
        /*

        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        
        if (dateString != currentDateString) {
            [user setValue:@0.0 forKey:@"consumed"];
            [user setValue:[NSDate date] forKey:@"updatedAt"];
            [user saveInBackground];
        }*/
    }
}

@end
