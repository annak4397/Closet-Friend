//
//  OutfitDetailViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "OutfitDetailViewController.h"
#import "Item.h"
#import "ItemInOutfitTableViewCell.h"
#import "ItemDetailViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
@import Parse;

@interface OutfitDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *outfitImage;
@property (weak, nonatomic) IBOutlet UIButton *likedButton;
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UIButton *planButton;
- (IBAction)onPlanButtonTap:(id)sender;
- (IBAction)onLikeButtonTap:(id)sender;


@end

@implementation OutfitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemsTableView.dataSource = self;
    self.itemsTableView.delegate = self;
    [self loadScreen];
    [self setUpShare];
}
- (void)loadScreen{
    self.outfitImage.file = self.passedOutfit.image;
    [self.outfitImage loadInBackground];
    if(self.passedOutfit.liked == YES){
        self.likedButton.selected = YES;
    }
    else{
        self.likedButton.selected = NO;
    }
    if(self.passedOutfit.planned == YES){
        self.planButton.selected = YES;
    }
    else{
        self.planButton.selected = NO;
    }
    self.items = self.passedOutfit.items;
    [self.itemsTableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"itemDetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.itemsTableView indexPathForCell:tappedCell];
        Item *tappedItem = self.items[indexPath.row];
        
        ItemDetailViewController *detailController = [segue destinationViewController];
        detailController.itemPassed = tappedItem;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemInOutfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    Item *item = self.items[indexPath.row];
    [cell setItemCell:item];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (void) setUpShare {
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = self.outfitImage.image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    // since the share button doesn't show up in the storyboard I had to add the location myself based on the location of the price label. The + 60 and + 88 were the values that I found to work and place the button in the right place
    shareButton.center = CGPointMake(self.likedButton.center.x + 60, self.likedButton.center.y +88);
    [self.view addSubview:shareButton];
}
- (IBAction)onLikeButtonTap:(id)sender {
    if(self.likedButton.selected == NO){
        self.likedButton.selected = YES;
        self.passedOutfit.liked = YES;
        [self.passedOutfit saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"favorite outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
    else{
        self.likedButton.selected = NO;
        self.passedOutfit.liked = NO;
        [self.passedOutfit saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"un favorite outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
}

- (IBAction)onPlanButtonTap:(id)sender {
    if(self.planButton.selected == NO){
        self.planButton.selected = YES;
        self.passedOutfit.planned = YES;
        [self.passedOutfit saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"add to planned outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
    else{
        self.planButton.selected = NO;
        self.passedOutfit.planned = NO;
        [self.passedOutfit saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"un added to planned outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
}
@end
