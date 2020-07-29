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
#import "NewItemViewController.h"
#import "NewOutfitViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"

@interface ClosetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ClosetViewControllerDelegate, NewItemControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (strong, nonatomic) NSArray *itemsArray;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *closetLayoutViewFlow;
@property (strong, nonatomic) NSString *sortClosetBy;
@property (strong, nonatomic) NSArray *sortTypes;
@property (strong, nonatomic) NSArray *seasonTypes;
@property (strong, nonatomic) NSArray *itemTypes;
@property (strong, nonatomic) NSArray *seasonTypesSelected;
@property (strong, nonatomic) NSArray *itemTypesSelected;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
- (IBAction)onSelectButtonTap:(id)sender;
@property BOOL selectEnabled;
@property (strong, nonatomic) NSMutableArray *selectedItems;
- (IBAction)onLogoutButtonTap:(id)sender;

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
    self.sortTypes = @[@"Newest to oldest", @"Oldest to newest", @"Price high to low", @"Price low to high", @"Times worn high to low", @"Times worn low to high"];
    self.itemTypes = @[@"Shirt", @"Jacket", @"Dress", @"Skirt", @"Pants", @"Shorts",  @"Shoes"];
    self.seasonTypes = @[@"Spring", @"Summer", @"Fall", @"Winter"];
    self.sortClosetBy = self.sortTypes[0];
    self.seasonTypesSelected = self.seasonTypes;
    self.itemTypesSelected = self.itemTypes;
    
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
    [self filterCloset:self.sortClosetBy withSeasons:self.seasonTypesSelected withTypes:self.itemTypesSelected];
}

- (void)filterCloset:(NSString *)sortBY withSeasons: (NSArray *)seasons withTypes:(nonnull NSArray *)types{
    self.sortClosetBy = sortBY;
    self.seasonTypesSelected = seasons;
    self.itemTypesSelected = types;
    
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    
    [itemQuery whereKey:@"seasons" containedIn:self.seasonTypesSelected];
    [itemQuery whereKey:@"type" containedIn:self.itemTypesSelected];
    
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
        case 4:
            [itemQuery orderByDescending:@"numberOfTimesWorn"];
            break;
        case 5:
            [itemQuery orderByAscending:@"numberOfTimesWorn"];
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
    else if([[segue identifier] isEqualToString:@"newItemSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        NewItemViewController *newItemController = (NewItemViewController*)navigationController.topViewController;
        newItemController.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"outfitCreationSegue"]) {
        NewOutfitViewController *outfitController = [segue destinationViewController];
        
        outfitController.itemsPassed = [NSMutableArray arrayWithArray:self.selectedItems];
    }
    
}
-(void) didAddNewItem{
    [self loadItems];
}

- (IBAction)onSelectButtonTap:(id)sender {
    if(self.selectEnabled){
        [self performSegueWithIdentifier:@"outfitCreationSegue" sender:nil];
         
        // Deselect all selected items
        for(NSIndexPath *indexPath in self.itemCollectionView.indexPathsForSelectedItems) {
            [self.itemCollectionView deselectItemAtIndexPath:indexPath animated:NO];
            ClosetCollectionViewCell *cell = (ClosetCollectionViewCell *)[self.itemCollectionView cellForItemAtIndexPath:indexPath];
            [cell updateSelection];
        }
        
        // Remove all items from selectedRecipes array
        [self.selectedItems removeAllObjects];
        
        // Change the sharing mode to NO
        self.selectEnabled = NO;
        self.itemCollectionView.allowsMultipleSelection = NO;
        self.selectButton.selected = NO;
    }
    else{
        self.selectedItems = [[NSMutableArray alloc] init];
        self.selectButton.selected = YES;
        self.itemCollectionView.allowsMultipleSelection = YES;
        self.selectEnabled = YES;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectEnabled){
        ClosetCollectionViewCell *cell = (ClosetCollectionViewCell *)[self.itemCollectionView cellForItemAtIndexPath:indexPath];
        [cell updateSelection];
        NSLog(@"%@", self.itemsArray[indexPath.item]);
        Item *selectedItem = self.itemsArray[indexPath.item];
        [self.selectedItems addObject:selectedItem];
    }
    else{
        [self performSegueWithIdentifier:@"itemDetailSegue" sender:[self.itemCollectionView cellForItemAtIndexPath:indexPath]];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectEnabled){
        ClosetCollectionViewCell *cell = (ClosetCollectionViewCell *)[self.itemCollectionView cellForItemAtIndexPath:indexPath];
        [cell updateSelection];
        Item *deselectedItem = self.itemsArray[indexPath.item];
        [self.selectedItems removeObject:deselectedItem];
    }
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
@end
