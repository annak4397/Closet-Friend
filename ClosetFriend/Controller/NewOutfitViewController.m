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
#import <UIKit/UIKit.h>
#import "Constants.h"
@import Parse;

@interface NewOutfitViewController ()<SelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
- (IBAction)onSelectButtonTap:(id)sender;
@property (strong, nonatomic) NSArray *seasons;
@property (weak, nonatomic) IBOutlet PFImageView *outfitImageView;
@property (strong, nonatomic) NSMutableArray *itemsInOutfit;
@property (strong, nonatomic) NSMutableArray *imagesFromItems;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
- (IBAction)onBookmarkButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *seasonTitleLabel;
@property (strong, nonatomic) dispatch_group_t group;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) Outfit *outfitCreated;
@property (strong, nonatomic) NSArray *allItems;
@property (weak, nonatomic) IBOutlet UIButton *plannedOutfitButton;
- (IBAction)onPlannedOutfitTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *yourOutftiLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *textViewDisplay;

@end

@implementation NewOutfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.heartImage.alpha = 0;
    self.outfitImageView.image = NULL;
    self.bookmarkButton.hidden = YES;
    self.plannedOutfitButton.hidden = YES;
    
    // set up for outfit from single item or from array of items
    if(self.itemPassed != NULL || self.itemsPassed.count != 0){
        self.seasonTitleLabel.text = @"";
        self.seasonLabel.text = @"";
        self.selectButton.hidden = YES;
        self.yourOutftiLabel.text = @"Your outfit:";
        [self.activityIndicator startAnimating];
        self.imageTopConstraint.constant = 50;
        self.textViewDisplay.alpha = 0;
        if(self.itemPassed != NULL){
            [self queryFromAnItem: self.itemPassed];
        }
        else{
            [self setItemsInOutfitFromArray:self.itemsPassed];
        }
    }
    //set up for random outfit
    else{
        self.imageTopConstraint.constant = 98.5;
        self.seasonLabel.text = @"Season:";
        self.seasonLabel.text = @"Select a season";
        self.seasons = @[@"Spring", @"Summer", @"Fall", @"Winter", @"Any season"];
        self.textViewDisplay.alpha = .75;
        self.yourOutftiLabel.text = @"";
        self.selectButton.hidden = NO;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.outfitImageView setUserInteractionEnabled:YES];
    [self.outfitImageView addGestureRecognizer:tapGestureRecognizer];
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.itemPassed == NULL && self.itemsPassed.count == 0){
        self.heartImage.alpha = 0;
        self.outfitImageView.image = NULL;
        self.bookmarkButton.hidden = YES;
        self.plannedOutfitButton.hidden = YES;
        self.seasonLabel.text = @"Season:";
        self.seasonLabel.text = @"Select a season";
        self.seasons = @[@"Spring", @"Summer", @"Fall", @"Winter", @"Any season"];
        self.textViewDisplay.alpha = .75;
        self.yourOutftiLabel.text = @"";
        self.selectButton.hidden = NO;
    }
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
    [self.activityIndicator startAnimating];
    self.textViewDisplay.alpha = 0;
    self.allItems = [[NSArray alloc] init];
    self.outfitImageView.image = NULL;
    self.bookmarkButton.hidden = YES;
    // get all the items for that season
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    if(![self.seasonLabel.text isEqualToString:@"Any season"]){
        [itemQuery whereKey:@"seasons" equalTo: self.seasonLabel.text];
    }
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.allItems = items;
            [self setItemsInOutfit];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (void) queryFromAnItem: (Item *)itemGiven{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery whereKey:@"seasons" equalTo: itemGiven.seasons];
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if (items != nil) {
            self.allItems = items;
            [self setItemsInOutfitFrom: itemGiven];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) setItemsInOutfitFromArray: (NSMutableArray *) itemsGiven{
    self.group = dispatch_group_create();
    self.itemsInOutfit = itemsGiven;
    [self getImagesFromItems:self.itemsInOutfit];
    [self makeOutift];
}

- (void) setItemsInOutfitFrom: (Item *) itemGiven{
    self.group = dispatch_group_create();
    [self getItemsFromAnItem: itemGiven];
    [self getImagesFromItems:self.itemsInOutfit];
    [self makeOutift];
}

-(void) getItemsFromAnItem: (Item *) itemGiven{
    self.itemsInOutfit = [[NSMutableArray alloc] init];
    int randomNumber = arc4random();
    if([itemGiven.type isEqualToString:@"Shoes"]){
        // choose a random outfit but add the shoes at the end
        // do i choose a dress?
        randomNumber = arc4random() % 2;
        // yes dress
        if(randomNumber == 1){
            [self getDress];
        }
        // no choose an outfit with a shirt
        else{
            [self maybeGetJacket];
            [self getShirt];
            [self getBottom];
        }
        [self.itemsInOutfit addObject:itemGiven];
    }
    else if([itemGiven.type isEqualToString:@"Dress"]){
        //just add item and shoes
        [self.itemsInOutfit addObject:itemGiven];
        [self getShoes];
    }
    else if([itemGiven.type isEqualToString:@"Jacket"]){
        //add jacket
        [self.itemsInOutfit addObject:itemGiven];
        [self getShirt];
        [self getBottom];
        [self getShoes];
    }
    else if([itemGiven.type isEqualToString:@"Shirt"]){
        [self maybeGetJacket];
        //add the shirt
        [self.itemsInOutfit addObject:itemGiven];
        [self getBottom];
        [self getShoes];
    }
    else{
        // item is a bottom piece
        [self maybeGetJacket];
        [self getShirt];
        //add the bottom
        [self.itemsInOutfit addObject:itemGiven];
        [self getShoes];
    }
}

// gets the items for the outfit in a spesific season
- (void)setItemsInOutfit{
    self.group = dispatch_group_create();
    self.yourOutftiLabel.text = @"Your outfit:";
    [self getRandomItemsInOutfit];
    [self getImagesFromItems:self.itemsInOutfit];
    [self makeOutift];
}

- (NSArray *) getAllItemsOfType: (NSString *) type{
    NSMutableArray *itemsFound = [[NSMutableArray alloc] init];
    for(Item *currentItem in self.allItems){
        if([currentItem.type isEqualToString:type]){
            [itemsFound addObject:currentItem];
        }
    }
    return itemsFound;
}

- (void) getRandomItemsInOutfit{
    self.itemsInOutfit = [[NSMutableArray alloc] init];
    // do i choose a dress?
    int randomNumber = arc4random() % 2;
    // yes dress
    if(randomNumber == 1){
        [self getDress];
    }
    // no choose an outfit with a shirt
    else{
        [self maybeGetJacket];
        [self getShirt];
        [self getBottom];
    }
    [self getShoes];
}

-(void) getDress{
    NSArray *dresses = [self getAllItemsOfType:@"Dress"];
    int randomNumber = arc4random() % dresses.count;
    [self.itemsInOutfit addObject:dresses[randomNumber]];
}

-(void) maybeGetJacket{
    // choose if there will be a jacket
    int randomNumber = arc4random() % 2;
    // if yes, add jacket
    if(randomNumber == 1){
        NSArray *jackets = [self getAllItemsOfType:@"Jacket"];
        randomNumber = arc4random() % jackets.count;
        [self.itemsInOutfit addObject:jackets[randomNumber]];
    }
}

-(void) getShirt{
    NSArray *shirts = [self getAllItemsOfType:@"Shirt"];
    int randomNumber = arc4random() % shirts.count;
    [self.itemsInOutfit addObject:shirts[randomNumber]];
}

-(void) getBottom{
    // choose bottom type
    int randomNumber = (arc4random() % 3);
    NSString *typeOfBottom;
    switch (randomNumber) {
        case 0:
            typeOfBottom = @"Skirt";
            break;
        case 1:
            typeOfBottom = @"Pants";
            break;
        case 2:
            typeOfBottom = @"Shorts";
            break;
    }
    
    // choose bottoms
    NSArray *bottoms = [self getAllItemsOfType:typeOfBottom];
    randomNumber = arc4random() % bottoms.count;
    [self.itemsInOutfit addObject:bottoms[randomNumber]];
}

-(void) getShoes{
    NSArray *shoes = [self getAllItemsOfType:@"Shoes"];
    int randomNumber = arc4random() % shoes.count;
    [self.itemsInOutfit addObject:shoes[randomNumber]];
}

// use this for multiple images
-(void)getImagesFromItems:(NSArray *)items{
    // populates the imagesFromItems array and then replaces it with the image to keep the right order
    self.imagesFromItems = [NSMutableArray arrayWithCapacity:items.count];
    for(Item* item in items){
        [self.imagesFromItems addObject:item];
        dispatch_group_enter(self.group);
        [item[@"image"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(data){
                UIImage *image = [UIImage imageWithData:data];
                [self.imagesFromItems replaceObjectAtIndex:[items indexOfObject:item] withObject:image];
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
        y += height;
        height = currentImage.size.height;
        width = size.width;
        [currentImage drawInRect:CGRectMake(0,y,width, height)];
    }

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

-(void) makeOutift{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
        NSLog(@"got all the images");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.outfitImageView.image = [self imageByCombiningImage:self.imagesFromItems];
            self.bookmarkButton.hidden = NO;
            self.plannedOutfitButton.hidden = NO;
            [self.activityIndicator stopAnimating];
            int totalPrice = 0;
            for (Item *currentItem in self.itemsInOutfit){
                totalPrice += currentItem.price;
            }
            
            self.outfitCreated = [Outfit postOutfit:self.outfitImageView.image withItems:self.itemsInOutfit withSeason:self.seasonLabel.text withPrice:totalPrice withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"soemthing went wrong: %@", error.localizedDescription);
                }
                else{
                    NSLog(@"Saved outfit!");
                }
            }];
        });
    });
}

// favorite the outfit
- (IBAction)onBookmarkButtonTap:(id)sender {
    if(self.bookmarkButton.selected == NO){
        self.bookmarkButton.selected = YES;
        self.outfitCreated.liked = YES;
        [self.outfitCreated saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"favorite outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
    else{
        self.bookmarkButton.selected = NO;
        self.outfitCreated.liked = NO;
        [self.outfitCreated saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"un favorite outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
}
- (IBAction)didTap:(UITapGestureRecognizer *)sender {
    NSLog(@"did double tap");
    if(!self.bookmarkButton.selected){
        self.heartImage.image = [UIImage imageNamed: @"651px-Love_Heart_symbol.svg"];
    }
    else{
        self.heartImage.image = [UIImage imageNamed: @"1250px-Broken_heart.svg"];
    }
    [UIView animateWithDuration: TIME_FOR_ANIMATION animations:^{
        self.heartImage.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TIME_FOR_ANIMATION animations:^{
            self.heartImage.alpha = 0;
        }];
    }];
    [self onBookmarkButtonTap:nil];
}
- (IBAction)onPlannedOutfitTap:(id)sender {
    if(self.plannedOutfitButton.selected == NO){
        self.plannedOutfitButton.selected = YES;
        self.outfitCreated.planned = YES;
        [self.outfitCreated saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"add to planned outfit");
            }
            else{
                NSLog(@"error :%@", error.localizedDescription);
            }
        }];
    }
    else{
        self.plannedOutfitButton.selected = NO;
        self.outfitCreated.planned = NO;
        [self.outfitCreated saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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
