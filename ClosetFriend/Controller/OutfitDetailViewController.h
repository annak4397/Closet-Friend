//
//  OutfitDetailViewController.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Outfit.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutfitDetailViewController : UIViewController
@property (strong, nonatomic) Outfit *passedOutfit;
@end

NS_ASSUME_NONNULL_END
