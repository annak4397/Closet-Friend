//
//  ItemInOutfitTableViewCell.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/17/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ItemInOutfitTableViewCell : UITableViewCell
-(void)setItemCell:(Item *)itemPassed;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) Item *cellItem;
@end

NS_ASSUME_NONNULL_END
