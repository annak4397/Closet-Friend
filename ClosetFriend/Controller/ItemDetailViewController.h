//
//  ItemDetailViewController.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailViewController : UIViewController
@property (strong, nonatomic) Item *itemPassed;
@end

NS_ASSUME_NONNULL_END
