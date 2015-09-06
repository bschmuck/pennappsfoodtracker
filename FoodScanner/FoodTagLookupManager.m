//
//  FoodTagLookupManager.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/5/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodTagLookupManager.h"

@implementation FoodTagLookupManager

- (id)init{
    self = [super init];
    self.filterKeys = @[@"banana", @"pizza", @"coffee", @"bread"];
    return self;
}

/**
 Called once tags have been retrieved for a given image
 */
- (void)FoodRecognitionManager:(FoodRecognitionManager *)manager didRetrieveTags:(NSArray *)tags{
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"output" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonFilePath encoding:NSUTF8StringEncoding error:nil];
    NSData *foodData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *foodDataDict = [NSJSONSerialization JSONObjectWithData:foodData options:0 error:&error];
    
    if(error){
        NSLog(@"%@", [error description]);
    }
    
    NSMutableArray *filteredTags = [[NSMutableArray alloc] init];
    for(NSString *tag in tags){
        if([self.filterKeys containsObject:tag]){
            [filteredTags addObject:tag];
        }
    }
    
    NSMutableDictionary *possibilitiesDictionary = [[NSMutableDictionary alloc] init];
        
    for(NSString *tag in filteredTags){
        for(NSString *foodItem in [foodDataDict allKeys]){
            if([foodItem rangeOfString:[tag uppercaseString]].location == 0){
                NSLog(@"%@", foodItem);
                possibilitiesDictionary[[foodItem lowercaseString]] = foodDataDict[foodItem];
            }
        }
    }
    [self.delegate FoodTagLookupManager:self didReceiveItemPossibilities:possibilitiesDictionary];
    
}

@end
