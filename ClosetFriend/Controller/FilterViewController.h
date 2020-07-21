//
//  FilterViewController.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/21/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ClosetViewControllerDelegate

- (void)filterCloset: (NSString *)sortBY;

@end

@interface FilterViewController : UIViewController
@property (nonatomic, weak) id<ClosetViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
