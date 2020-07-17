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

@interface NewOutfitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
- (IBAction)onSelectButtonTap:(id)sender;
- (IBAction)onGenerateButtonTap:(id)sender;
@property (strong, nonatomic) NSArray *seasons;
@property (weak, nonatomic) IBOutlet PFImageView *outfitImageView;
@property (strong, nonatomic) NSArray *itemsInOutfit;
@property (strong, nonatomic) NSMutableArray *imagesFromItems;
- (IBAction)onCreateButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
- (IBAction)onBookmarkButtonTap:(id)sender;
@property (weak, nonatomic) Outfit *generatedOutfit;

@end

@implementation NewOutfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.seasons = @[@"Winter", @"Spring", @"Summer", @"Fall"];
    [self setItemsInOutfit];
    self.imagesFromItems = [[NSMutableArray alloc] init];
    [self clearScreen];
}
-(void)viewDidAppear:(BOOL)animated{
    [self clearScreen];
}
-(void)clearScreen{
    self.seasonLabel.text = @"Select a season";
    self.outfitImageView.image = NULL;
    self.bookmarkButton.hidden = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"selectionScreenSegue"]) {
        SelectorToolViewController *selectorController = [segue destinationViewController];
        selectorController.selectionItems = self.seasons;
        selectorController.delegate = self.seasonLabel;
        selectorController.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        selectorController.modalPresentationStyle = UIModalPresentationCustom;
    }
}

- (IBAction)onGenerateButtonTap:(id)sender {
    
    [self.itemsInOutfit[0][@"image"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(data){
            NSLog(@"got the data");
            UIImage *image = [UIImage imageWithData:data];
            [self.imagesFromItems insertObject:image atIndex:0];
        }
        if(error){
            NSLog(@"there was an error %@", error.localizedDescription);
        }
    }];
    [self.itemsInOutfit[1][@"image"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(data){
            NSLog(@"got the data");
            UIImage *image = [UIImage imageWithData:data];
            [self.imagesFromItems insertObject:image atIndex:0];
        }
        if(error){
            NSLog(@"there was an error %@", error.localizedDescription);
        }
    }];
}

- (void)setItemsInOutfit{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    itemQuery.limit = 2;
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.itemsInOutfit = items;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)getImagesFromItems:(NSArray *)items withImages: (NSMutableArray *)images{
    //NSMutableArray *imagesFromItems = [[NSMutableArray alloc] init];
    for(Item* item in items){
        //UIImage *image = [[UIImage alloc] init];
        [item[@"image"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(data){
                UIImage *image = [UIImage imageWithData:data];
                [images insertObject:image atIndex:0];
            }
            if(error){
                NSLog(@"there was an error %@", error.localizedDescription);
            }
        }];
    }
    //return imagesFromItems;
}

- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image1 = firstImage;
    UIImage *image2 = secondImage;

    CGSize size = CGSizeMake(image1.size.width, image1.size.height + image2.size.height);

    UIGraphicsBeginImageContext(size);

    [image1 drawInRect:CGRectMake(0,0,size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0,image1.size.height,size.width, image2.size.height)];

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    //set finalImage to IBOulet UIImageView
    return finalImage;
}

- (IBAction)onSelectButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"selectionScreenSegue" sender:sender];
}
- (IBAction)onCreateButtonTap:(id)sender {
    self.outfitImageView.image = [self imageByCombiningImage:self.imagesFromItems[0] withImage:self.imagesFromItems[1]];
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
