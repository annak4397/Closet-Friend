//
//  ClosetCollectionViewCell.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ClosetCollectionViewCell.h"

@implementation ClosetCollectionViewCell
-(void)setCellItem:(Item *)itemPassed{
    self.selectedButton.selected = self.selectedButton.selected;
    self.itemImage.file = itemPassed[@"image"];
    [self.itemImage loadInBackground];
}
-(void)updateSelection{
    self.selectedButton.selected = !self.selectedButton.selected;
}
@end
