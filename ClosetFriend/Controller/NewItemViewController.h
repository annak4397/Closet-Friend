//
//  NewItemViewController.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewItemViewControllerDelegate

- (void)didCreateNewItem;

@end

@interface NewItemViewController : UIViewController

@property (nonatomic, weak) id<NewItemViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END