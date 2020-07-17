//
//  Outfit.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "Outfit.h"
#import "Item.h"

@implementation Outfit

@dynamic author;
@dynamic items;
@dynamic price;
@dynamic season;
@dynamic liked;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Outfit";
}

//change to my own saving method
+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    /*Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];*/
}

+ (void) postOutfit: ( UIImage * _Nullable )image withItems: (NSArray *)items withSeason: (NSString *)season withPrice: (int)price withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Outfit *newOutfit = [Outfit new];
    
    newOutfit.image = [Item getPFFileFromImage:image];
    newOutfit.season = season;
    newOutfit.price = price;
    newOutfit.author = [PFUser currentUser];

    
    [newOutfit saveInBackgroundWithBlock: completion];
}

@end
