//
//  NewOutfitViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/16/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "NewOutfitViewController.h"
#import "SelectorToolViewController.h"
#import "Item.h"
#import "Outfit.h"
@import Parse;

@interface NewOutfitViewController ()<SelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
- (IBAction)onSelectButtonTap:(id)sender;
@property (strong, nonatomic) NSArray *seasons;
@property (weak, nonatomic) IBOutlet PFImageView *outfitImageView;
@property (strong, nonatomic) NSArray *itemsInOutfit;
@property (strong, nonatomic) NSMutableArray *imagesFromItems;
- (IBAction)onCreateButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
- (IBAction)onBookmarkButtonTap:(id)sender;
@property (weak, nonatomic) Outfit *generatedOutfit;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) dispatch_group_t group;

@end

@implementation NewOutfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.seasons = @[@"Winter", @"Spring", @"Summer", @"Fall"];
    self.group = dispatch_group_create();
    [self clearScreen];
}
-(void)viewDidAppear:(BOOL)animated{
    [self clearScreen];
}
-(void)clearScreen{
    self.seasonLabel.text = @"Select a season";
    self.outfitImageView.image = NULL;
    self.bookmarkButton.hidden = YES;
    self.createButton.hidden = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (IBAction)onSelectButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"selectionScreenSegue" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Gets season
    if([[segue identifier] isEqualToString:@"selectionScreenSegue"]) {
        SelectorToolViewController *selectorController = [segue destinationViewController];
        selectorController.selectionItems = self.seasons;
        selectorController.label = self.seasonLabel;
        selectorController.delegate = self;
        selectorController.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        selectorController.modalPresentationStyle = UIModalPresentationCustom;
    }
}
- (void)didSelectSeason{
    [self setItemsInOutfit];
}

// gets the items for the outfit in a spesific season
- (void)setItemsInOutfit{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    itemQuery.limit = 2;
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.itemsInOutfit = items;
            [self getImagesFromItems:self.itemsInOutfit];
            dispatch_group_wait(self.group, 3);
            self.createButton.hidden = NO;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// use this for multiple images
-(void)getImagesFromItems:(NSArray *)items{
    self.imagesFromItems = [[NSMutableArray alloc] init];
    
    for(Item* item in items){
        dispatch_group_enter(self.group);
        [item[@"image"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(data){
                UIImage *image = [UIImage imageWithData:data];
                [self.imagesFromItems insertObject:image atIndex:0];
                dispatch_group_leave(self.group);
            }
            if(error){
                NSLog(@"there was an error %@", error.localizedDescription);
            }
        }];
    }
}

// combine the images to get one
- (UIImage*)imageByCombiningImage:(NSArray *)images {
    CGFloat height = 0;
    CGFloat width = 0;
    
    for(UIImage *image in images){
        width = MAX(width,image.size.width);
        height += image.size.height;
    }

    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    
    CGFloat y = 0;
    width = 0;
    height = 0;
    for(int i = 0; i < images.count; i++){
        UIImage *currentImage = images[i];
        y = height;
        height += currentImage.size.height;
        width = size.width;
        [currentImage drawInRect:CGRectMake(0,y,width, height)];
    }

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

// make the outfit and save it
- (IBAction)onCreateButtonTap:(id)sender {
    self.outfitImageView.image = [self imageByCombiningImage:self.imagesFromItems];
    self.bookmarkButton.hidden = NO;
    int totalPrice = 0;
    for (Item *currentItem in self.itemsInOutfit){
        totalPrice += currentItem.price;
    }
    
    [Outfit postOutfit:self.outfitImageView.image withItems:self.itemsInOutfit withSeason:self.seasonLabel.text withPrice:totalPrice withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"soemthing went wrong: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Saved outfit!");
        }
    }];
}

// favorite the outfit
- (IBAction)onBookmarkButtonTap:(id)sender {
    self.bookmarkButton.selected = YES;
    
    PFQuery *outfitQuery = [PFQuery queryWithClassName:@"Outfit"];
    [outfitQuery orderByDescending:@"createdAt"];
    outfitQuery.limit = 1;
    [outfitQuery findObjectsInBackgroundWithBlock:^(NSArray *outfits, NSError *error) {
        if (outfits != nil) {
            self.generatedOutfit = outfits[0];
            self.generatedOutfit.liked = YES;
            [self.generatedOutfit saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    NSLog(@"favotired outfit");
                }
                else{
                    NSLog(@"error :%@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}
@end
