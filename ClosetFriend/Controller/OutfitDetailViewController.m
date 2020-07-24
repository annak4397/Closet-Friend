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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *likedButton;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) NSArray *items;

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
    self.priceLabel.text = [NSString stringWithFormat:@"%d", self.passedOutfit.price];
    self.seasonLabel.text = self.passedOutfit.season;
    if(self.passedOutfit.liked == YES){
        self.likedButton.selected = YES;
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
    shareButton.center = CGPointMake(self.priceLabel.layer.position.x + 210, self.priceLabel.layer.position.y + 95);
    [self.view addSubview:shareButton];
}
@end
