//
//  ItemDetailViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ItemDetailViewController.h"
@import Parse;

@interface ItemDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerWearLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesWornLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemImage.file = self.itemPassed.image;
    [self.itemImage loadInBackground];
    self.descriptionLabel.text = self.itemPassed[@"description"];
    self.sizeLabel.text = self.itemPassed.size;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", self.itemPassed.price];
    self.pricePerWearLabel.text = [NSString stringWithFormat:@"%@", self.itemPassed.pricePerWear];
    self.timesWornLabel.text = [NSString stringWithFormat:@"%@", self.itemPassed.numberOfTimesWorn];
    self.typeLabel.text = self.itemPassed.type;
    self.seasonLabel.text = self.itemPassed.seasons;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
