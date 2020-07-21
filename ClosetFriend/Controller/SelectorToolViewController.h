//
//  SelectorToolViewController.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectViewControllerDelegate

- (void)didSelectSeason;

@end

@interface SelectorToolViewController : UIViewController
@property (weak, nonatomic) NSArray *selectionItems;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) NSString *string;
@property double tabBarHeight;
@property (nonatomic, weak) id<SelectViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
