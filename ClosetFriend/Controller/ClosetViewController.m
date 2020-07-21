//
//  ClosetViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ClosetViewController.h"
#import "Item.h"
#import "ClosetCollectionViewCell.h"
#import "ItemDetailViewController.h"
#import "FilterViewController.h"

@interface ClosetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ClosetViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (strong, nonatomic) NSArray *itemsArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *closetLayoutViewFlow;
@property (strong, nonatomic) NSString *sortClosetBy;
@property (strong, nonatomic) NSArray *sortTypes;

@end

@implementation ClosetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemCollectionView.dataSource = self;
    self.itemCollectionView.delegate = self;
    // Do any additional setup after loading the view.
    
    CGFloat cellWidth = self.itemCollectionView.frame.size.width/3;
    CGFloat cellHeight = cellWidth;
    self.closetLayoutViewFlow.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.closetLayoutViewFlow.minimumLineSpacing = 0;
    self.closetLayoutViewFlow.minimumInteritemSpacing = 0;
    
    // if I keep the mini closet on the main page I will need to change this becuase it resets the filter preferences
    self.sortTypes = @[@"Newest to oldest", @"Oldest to newest", @"Price high to low", @"Price low to high"];
    self.sortClosetBy = self.sortTypes[0];
    
    [self loadItems];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClosetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    Item *item = self.itemsArray[indexPath.row];
    [cell setCellItem:item];
    return cell;
    
}
- (void) loadItems{
    [self filterCloset:self.sortClosetBy];
}

- (void)filterCloset:(NSString *)sortBY{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    self.sortClosetBy = sortBY;
    switch ([self.sortTypes indexOfObject:sortBY]) {
        case 0:
            [itemQuery orderByDescending:@"createdAt"];
            break;
        case 1:
            [itemQuery orderByAscending:@"createdAt"];
            break;
        case 2:
            [itemQuery orderByDescending:@"price"];
            break;
        case 3:
            [itemQuery orderByAscending:@"price"];
            break;
    }
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.itemsArray = items;
            [self.itemCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"itemDetailSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.itemCollectionView indexPathForCell:tappedCell];
        Item *tappedItem = self.itemsArray[indexPath.row];
        ItemDetailViewController *detailController = [segue destinationViewController];
        detailController.itemPassed = tappedItem;
    }
    else if([[segue identifier] isEqualToString:@"filterSegue"]) {
        FilterViewController *filterController = [segue destinationViewController];
        filterController.delegate = self;
    }
}

@end
