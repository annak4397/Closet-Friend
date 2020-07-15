//
//  ClosetCollectionViewCell.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Item.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ClosetCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
-(void)setCellItem:(Item *)itemPassed;
@end

NS_ASSUME_NONNULL_END