//
//  Item.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "Item.h"
#import <Parse/Parse.h>

@implementation Item

@dynamic itemID;
@dynamic author;
@dynamic image;
@dynamic description;
@dynamic seasons;
@dynamic size;
@dynamic type;
@dynamic price;
@dynamic numberOfTimesWorn;
@dynamic pricePerWear;

+ (nonnull NSString *)parseClassName {
    return @"Item";
}

+ (void) postItem: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    /*Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];*/
}

+ (void) postItemWithImage: ( UIImage * _Nullable )image withDescription: (NSString *)description withSeason: (NSString *)season withSize: (NSString *)size withType: (NSString *)type withPrice: (int)price withCompletion: (PFBooleanResultBlock _Nullable)completion{
    
    Item *newItem = [Item new];
    newItem.image = [self getPFFileFromImage:image];
    newItem[@"description"] = description;
    newItem.seasons = season;
    newItem.type = type;
    newItem.author = [PFUser currentUser];
    newItem.size = size;
    newItem.price = price;
    newItem.numberOfTimesWorn = 0;
    newItem.pricePerWear = price;
    
    [newItem saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end

