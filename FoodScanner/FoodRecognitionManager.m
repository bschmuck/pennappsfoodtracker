//
//  FoodRecognitionManager.m
//  FoodScanner
//
//  Created by Brandon Schmuck on 9/4/15.
//  Copyright © 2015 Brandon Schmuck. All rights reserved.
//

#import "FoodRecognitionManager.h"
#import <Parse/Parse.h>

//Client IDs for Clarifais
const NSString *kClientID = @"pTOy8mgm3B81gM4vKtkRTDTQ4-4vuDDlFygoJjDm";
const NSString *kClientSecret = @"ny_DUk-NsLTKraFr9OpEdAAKKdRoU_-QisZsgJc4";

@interface FoodRecognitionManager()

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSMutableArray *tags;

@end

@implementation FoodRecognitionManager

- (id)init{
    self = [super init];
    self.tags = [[NSMutableArray alloc] init];
    return self;
}

/**
 Intialize a Clarifai Session
 */
- (void)initializeSession{
    NSString *tokenRequestURLString = @"https://api.clarifai.com/v1/token/";
    NSURL *tokenRequestURL = [NSURL URLWithString:tokenRequestURLString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenRequestURL];
    [request setHTTPMethod:@"POST"];
    NSString *args = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@", kClientID, kClientSecret];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&error];
    self.accessToken = returnDict[@"access_token"];
}

/**
 Get information corresponding to a remote image
 located at a given URL
 */
- (void)getInformationFromRemoteImage:(NSString *)imageURLString{
    NSString *tagRequestURLString = @"https://api.clarifai.com/v1/tag/";
    NSURL *tagRequestURL = [NSURL URLWithString:tagRequestURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tagRequestURL];
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    
    
    NSString *args = [NSString stringWithFormat:@"url=%@", imageURLString];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&error];
    NSDictionary *resultsDict = [returnDict valueForKeyPath:@"results"];
    NSDictionary *resultDict = [resultsDict valueForKeyPath:@"result"];
    NSDictionary *tagDict = [resultDict valueForKeyPath:@"tag"];
    NSArray *tagArray = [tagDict valueForKeyPath:@"classes"];
    for(NSArray *tag in tagArray){
        self.tags = [tag mutableCopy];
    }
    NSLog(@"%@", self.tags);
    [self.delegate FoodRecognitionManager:self didRetrieveTags:self.tags];
    
}

/**
 Get information for a given image.
 */
- (void)getInformationForImage:(UIImage *)image{
    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:data];
    
    // Save the image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            PFObject* newPhotoObject = [PFObject objectWithClassName:@"PhotoObject"];
            [newPhotoObject setObject:imageFile forKey:@"image"];
            
            [newPhotoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                    NSString *imageURL = imageFile.url;
                    [self getInformationFromRemoteImage:imageURL];
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}



@end
