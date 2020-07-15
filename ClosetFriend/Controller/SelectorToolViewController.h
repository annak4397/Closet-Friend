//
//  SelectorToolViewController.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectorToolViewController : UIViewController
@property (weak, nonatomic) NSArray *selectionItems;
@property (weak, nonatomic) UITextField *delegate;
@property double tabBarHeight;
@end

NS_ASSUME_NONNULL_END
