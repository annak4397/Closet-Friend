//
//  FilterViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/21/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "FilterViewController.h"
#import "SelectorToolViewController.h"
#import "SceneDelegate.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sortTypeLabel;
- (IBAction)selectButton:(id)sender;
@property (strong, nonatomic) NSArray *sortTypes;
@property (strong, nonatomic) NSArray *itemTypes;
@property (strong, nonatomic) NSArray *seasonTypes;
@property (weak, nonatomic) IBOutlet UISwitch *springSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *summerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fallSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *winterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shirtSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jacketSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *skirtSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pantsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shortsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shoesSwitch;
@property (strong, nonatomic) NSArray *seasonsSwitches;
@property (strong, nonatomic) NSArray *typeSwitches;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sortTypes = @[@"Newest to oldest", @"Oldest to newest", @"Price high to low", @"Price low to high", @"Times worn high to low", @"Times worn low to high"];;
    self.itemTypes = @[@"Shirt", @"Jacket", @"Dress", @"Skirt", @"Pants", @"Shorts",  @"Shoes"];
    self.seasonTypes = @[@"Spring", @"Summer", @"Fall", @"Winter"];
    
    self.seasonsSwitches = @[self.springSwitch, self.summerSwitch, self.fallSwitch, self.winterSwitch];
    
    self.typeSwitches = @[self.shirtSwitch, self.jacketSwitch, self.dressSwitch, self.skirtSwitch, self.pantsSwitch, self.shortsSwitch, self.shoesSwitch];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"selectionScreenSegue"]) {
        SelectorToolViewController *selectorController = [segue destinationViewController];
        selectorController.selectionItems = self.sortTypes;
        selectorController.label = self.sortTypeLabel;
        selectorController.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        selectorController.modalPresentationStyle = UIModalPresentationCustom;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  if (self.isMovingFromParentViewController) {
      NSMutableArray *selectedSeasons = [[NSMutableArray alloc] init];
      for(int i = 0; i < self.seasonTypes.count; i++){
          UISwitch *currentSwitch = self.seasonsSwitches[i];
          if(currentSwitch.on){
              [selectedSeasons addObject:self.seasonTypes[i]];
          }
      }
      
      NSMutableArray *selectedTypes = [[NSMutableArray alloc] init];
      for(int i = 0; i < self.itemTypes.count; i++){
          UISwitch *currentSwitch = self.typeSwitches[i];
          if(currentSwitch.on){
              [selectedTypes addObject:self.itemTypes[i]];
          }
      }
      
      [self.delegate filterCloset:self.sortTypeLabel.text withSeasons:selectedSeasons withTypes:selectedTypes];
  }
}

- (IBAction)selectButton:(id)sender {
    [self performSegueWithIdentifier:@"selectionScreenSegue" sender:sender];
}
@end
