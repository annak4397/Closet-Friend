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
    if(itemPassed.isSelected){
        self.whiteView.alpha = .5;
    }
    else{
        self.whiteView.alpha = 0;
    }
    self.itemImage.file = itemPassed[@"image"];
    [self.itemImage loadInBackground];
}
-(void)updateSelection: (BOOL) selected{
    self.selectedButton.selected = selected;
    if(selected){
        self.whiteView.alpha = .5;
    }
    else{
        self.whiteView.alpha = 0;
    }
}
@end
