//
//  ItemInOutfitTableViewCell.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/17/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ItemInOutfitTableViewCell.h"

@implementation ItemInOutfitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItemCell:(Item *)itemPassed{
    self.cellItem = itemPassed;
    self.itemImage.file = itemPassed.image;
    [self.itemImage loadInBackground];
    self.priceLabel.text = [NSString stringWithFormat:@"%d", itemPassed.price];
    self.seasonLabel.text = itemPassed.seasons;
    self.typeLabel.text = itemPassed.type;
}
@end
