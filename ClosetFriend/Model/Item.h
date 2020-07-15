//
//  Item.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *description;
//make array as stretch
@property (nonatomic, strong) NSString *seasons;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *numberOfTimesWorn;
@property (nonatomic, strong) NSNumber *pricePerWear;

+ (void) postItem: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) postItemWithImage: ( UIImage * _Nullable )image withDescription: (NSString *)description withSeason: (NSString *)season withSize: (NSString *)size withType: (NSString *)type withPrice: (NSNumber *)price withCompletion: (PFBooleanResultBlock _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
