//
//  FavoriteOutfitViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "FavoriteOutfitViewController.h"
#import "FavoriteOutfitCollectionViewCell.h"
#import "Outfit.h"
#import "OutfitDetailViewController.h"

@interface FavoriteOutfitViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *outfitCollectionView;
@property (strong, nonatomic) NSArray *outfitsArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *favoriteOutfitViewFlow;
@end

@implementation FavoriteOutfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outfitCollectionView.dataSource = self;
    self.outfitCollectionView.delegate = self;
    
    CGFloat cellWidth = self.outfitCollectionView.frame.size.width/3;
    CGFloat cellHeight = cellWidth;
    self.favoriteOutfitViewFlow.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.favoriteOutfitViewFlow.minimumLineSpacing = 0;
    self.favoriteOutfitViewFlow.minimumInteritemSpacing = 0;
    
    [self loadFavoriteOutfits];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"outfitDetailSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.outfitCollectionView indexPathForCell:tappedCell];
        Outfit *tappedOutfit = self.outfitsArray[indexPath.row];
        OutfitDetailViewController *detailController = [segue destinationViewController];
        detailController.passedOutfit = tappedOutfit;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.outfitsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteOutfitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"outfitCell" forIndexPath:indexPath];
    Outfit *outfit = self.outfitsArray[indexPath.row];
    [cell setCellOutfit:outfit];

    return cell;
}

- (void) loadFavoriteOutfits{
    // add a sort to only show favorited outfits
    PFQuery *outfitQuery = [PFQuery queryWithClassName:@"Outfit"];
    [outfitQuery orderByDescending:@"createdAt"];
    outfitQuery.limit = 10;
    [outfitQuery findObjectsInBackgroundWithBlock:^(NSArray *outfits, NSError *error) {
        if (outfits != nil) {
            self.outfitsArray = outfits;
            //[self.loadingActivity stopAnimating];
            [self.outfitCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
