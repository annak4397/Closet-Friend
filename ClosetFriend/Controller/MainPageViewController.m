//
//  MainPageViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "MainPageViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "ItemCollectionViewCell.h"
#import "Item.h"
#import "OutfitCollectionViewCell.h"
#import "Outfit.h"
#import "ItemDetailViewController.h"
#import "OutfitDetailViewController.h"
#import "NewItemViewController.h"
#import "NewOutfitViewController.h"

@interface MainPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *plannedOutfitCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *plannedOutfitCollectionViewFlowLayout;
@property (strong, nonatomic) NSArray *plannedOutfitsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *outfitCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *outfitCollectionViewFlowLayout;
@property (strong, nonatomic) NSArray *outfitsArray;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.plannedOutfitCollectionView.dataSource = self;
    self.plannedOutfitCollectionView.delegate = self;
    
    self.outfitCollectionView.dataSource = self;
    self.outfitCollectionView.delegate = self;
    
    [self.plannedOutfitCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    CGFloat cellHeight = self.plannedOutfitCollectionView.frame.size.height;
    CGFloat cellWidth = cellHeight;
    self.plannedOutfitCollectionViewFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.plannedOutfitCollectionViewFlowLayout.minimumLineSpacing = 0;
    self.plannedOutfitCollectionViewFlowLayout.minimumInteritemSpacing = 0;
    
    cellWidth = self.outfitCollectionView.frame.size.width/3;
    cellHeight = cellWidth;
    self.outfitCollectionViewFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.outfitCollectionViewFlowLayout.minimumLineSpacing = 0;
    self.outfitCollectionViewFlowLayout.minimumInteritemSpacing = 0;
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath;
    Outfit *tappedOutfit;
    if([tappedCell.reuseIdentifier isEqualToString:@"itemCell"]){
        indexPath = [self.plannedOutfitCollectionView indexPathForCell:tappedCell];
        tappedOutfit = self.plannedOutfitsArray[indexPath.row];
    }
    else{
        indexPath = [self.outfitCollectionView indexPathForCell:tappedCell];
        tappedOutfit = self.outfitsArray[indexPath.row];
    }
    OutfitDetailViewController *detailController = [segue destinationViewController];
    detailController.passedOutfit = tappedOutfit;
}

- (void) loadData{
    PFQuery *plannedOutfitQuery = [PFQuery queryWithClassName:@"Outfit"];
    [plannedOutfitQuery orderByDescending:@"createdAt"];
    [plannedOutfitQuery whereKey:@"planned" equalTo:@(1)];
    [plannedOutfitQuery includeKey:@"items"];
    [plannedOutfitQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.plannedOutfitsArray = items;
            //[self.loadingActivity stopAnimating];
            [self.plannedOutfitCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *outfitQuery = [PFQuery queryWithClassName:@"Outfit"];
    [outfitQuery orderByDescending:@"createdAt"];
    [outfitQuery whereKey:@"liked" equalTo:@(1)];
    [outfitQuery includeKey:@"items"];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.plannedOutfitCollectionView){
        return self.plannedOutfitsArray.count;
    }
    return self.outfitsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.plannedOutfitCollectionView){
        ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
        Outfit *outfit = self.plannedOutfitsArray[indexPath.row];
        [cell setCellOutfit:outfit];

        return cell;
    }
    else{
        OutfitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"outfitCell" forIndexPath:indexPath];
        Outfit *outfit = self.outfitsArray[indexPath.row];
        [cell setCellOutfit:outfit];

        return cell;
    }
}
@end
