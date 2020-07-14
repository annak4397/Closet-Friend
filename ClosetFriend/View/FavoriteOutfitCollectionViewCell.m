//
//  FavoriteOutfitCollectionViewCell.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "FavoriteOutfitCollectionViewCell.h"

@implementation FavoriteOutfitCollectionViewCell
-(void)setCellOutfit:(Outfit *)outfitPassed{
    self.outfitImage.file = outfitPassed[@"image"];
    [self.outfitImage loadInBackground];
}
@end
