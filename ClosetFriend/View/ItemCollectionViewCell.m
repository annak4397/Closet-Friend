//
//  ItemCollectionViewCell.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@implementation ItemCollectionViewCell
-(void)setCellItem:(Item *)itemPassed{
    self.itemImage.file = itemPassed[@"image"];
    [self.itemImage loadInBackground];
}
@end
