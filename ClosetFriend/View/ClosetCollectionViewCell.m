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
    self.selectedButton.selected = itemPassed.isSelected;
    self.itemImage.file = itemPassed[@"image"];
    [self.itemImage loadInBackground];
}
-(void)updateSelection: (BOOL) selected{
    self.selectedButton.selected = selected;
}
@end
