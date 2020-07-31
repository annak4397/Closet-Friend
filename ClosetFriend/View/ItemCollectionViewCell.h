//
//  ItemCollectionViewCell.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

@import Parse;
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Outfit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *outfitImage;
-(void)setCellOutfit:(Outfit *)outfitPassed;
@end

NS_ASSUME_NONNULL_END
