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

@interface ClosetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (strong, nonatomic) NSArray *itemsArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *closetLayoutViewFlow;

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
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    itemQuery.limit = 10;
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.itemsArray = items;
            //[self.loadingActivity stopAnimating];
            [self.itemCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
