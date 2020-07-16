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
@import Parse;

@interface NewOutfitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
- (IBAction)onSelectButtonTap:(id)sender;
- (IBAction)onGenerateButtonTap:(id)sender;
@property (strong, nonatomic) NSArray *seasons;
@property (weak, nonatomic) IBOutlet PFImageView *outfitImageView;
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UIImageView *testImage2;
@property (strong, nonatomic) NSArray *itemsInOutfit;
@property (strong, nonatomic) NSMutableArray *imagesFromItems;
- (IBAction)onCreateButtonTap:(id)sender;

@end

@implementation NewOutfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.seasons = @[@"Winter", @"Spring", @"Summer", @"Fall"];
    [self setItemsInOutfit];
    /*UIImage *image1 = self.testImage.image;
    UIImage *image2 = self.testImage2.image;

    CGSize size = CGSizeMake(image1.size.width, image1.size.height + image2.size.height);

    UIGraphicsBeginImageContext(size);

    [image1 drawInRect:CGRectMake(0,0,size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0,image1.size.height,size.width, image2.size.height)];

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    //set finalImage to IBOulet UIImageView
    self.outfitImageView.image = finalImage;*/
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
            self.testImage.image = image;
        }
        if(error){
            NSLog(@"there was an error %@", error.localizedDescription);
        }
    }];
    [self.itemsInOutfit[1][@"image"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(data){
            NSLog(@"got the data");
            UIImage *image = [UIImage imageWithData:data];
            self.testImage2.image = image;
        }
        if(error){
            NSLog(@"there was an error %@", error.localizedDescription);
        }
    }];
    
    //will remove this later when i figure out how to handle the asyncness of data calls
    //self.outfitImageView.image = [self imageByCombiningImage:self.testImage.image withImage:self.testImage2.image];
    
    //self.testImage.file = self.itemsInOutfit[0][@"image"];
    //self.testImage2.file = self.itemsInOutfit[1][@"image"];
    
    /*[self.itemImage loadInBackground];
    
    self.imagesFromItems = [[NSMutableArray alloc] init];
    [self getImagesFromItems:self.itemsInOutfit withImages:self.imagesFromItems];
    self.outfitImageView.image = [self imageByCombiningImage:self.imagesFromItems[0] withImage:self.imagesFromItems[1]];*/
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
                NSLog(@"got the data");
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
    self.outfitImageView.image = [self imageByCombiningImage:self.testImage.image withImage:self.testImage2.image];
}
@end
