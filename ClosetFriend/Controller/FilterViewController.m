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
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sortTypes = @[@"Newest to oldest", @"Oldest to newest", @"Price high to low", @"Price low to high", @"Times worn high to low", @"Times worn low to high"];;
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
    [self.delegate filterCloset:self.sortTypeLabel.text];
  }
}

- (IBAction)selectButton:(id)sender {
    [self performSegueWithIdentifier:@"selectionScreenSegue" sender:sender];
}
@end
