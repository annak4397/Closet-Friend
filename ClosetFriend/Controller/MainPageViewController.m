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
#import "Outfit.h";
#import "ItemDetailViewController.h"
#import "OutfitDetailViewController.h"
#import "NewItemViewController.h"
#import "NewOutfitViewController.h"

@interface MainPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *itemsCollectionViewFlowLayout;
@property (strong, nonatomic) NSArray *itemsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *outfitCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *outfitCollectionViewFlowLayout;
@property (strong, nonatomic) NSArray *outfitsArray;

- (IBAction)onLogoutButtonTap:(id)sender;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemCollectionView.dataSource = self;
    self.itemCollectionView.delegate = self;
    
    self.outfitCollectionView.dataSource = self;
    self.outfitCollectionView.delegate = self;
    
    [self.itemsCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.outfitCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    CGFloat cellHeight = self.itemCollectionView.frame.size.height;
    CGFloat cellWidth = cellHeight;
    self.itemsCollectionViewFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.itemsCollectionViewFlowLayout.minimumLineSpacing = 0;
    self.itemsCollectionViewFlowLayout.minimumInteritemSpacing = 0;
    
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
    if([[segue identifier] isEqualToString:@"itemDetailSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.itemCollectionView indexPathForCell:tappedCell];
        Item *tappedItem = self.itemsArray[indexPath.row];
        ItemDetailViewController *detailController = [segue destinationViewController];
        detailController.itemPassed = tappedItem;
    }
    else if([[segue identifier] isEqualToString:@"outfitDetailSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.outfitCollectionView indexPathForCell:tappedCell];
        Outfit *tappedOutfit = self.outfitsArray[indexPath.row];
        OutfitDetailViewController *detailController = [segue destinationViewController];
        detailController.passedOutfit = tappedOutfit;
    }
}

- (void) loadData{
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
    
    PFQuery *outfitQuery = [PFQuery queryWithClassName:@"Outfit"];
    [outfitQuery orderByDescending:@"createdAt"];
    outfitQuery.limit = 10;
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

- (IBAction)onLogoutButtonTap:(id)sender {
    if([FBSDKAccessToken currentAccessToken]){
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"Some error occured during logout: %@", error.localizedDescription);
        }
    }];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.itemCollectionView){
        return self.itemsArray.count;
    }
    return self.outfitsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.itemCollectionView){
        ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
        Item *item = self.itemsArray[indexPath.row];
        [cell setCellItem:item];

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
