//
//  NewItemViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "NewItemViewController.h"
#import "SceneDelegate.h"
#import "MainPageViewController.h"
#import "SelectorToolViewController.h"
#import "Item.h"
#import <QuartzCore/QuartzCore.h>
@import Parse;

@interface NewItemViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextView;
@property (weak, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *seasonButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
- (IBAction)onSaveButtonTap:(id)sender;
- (IBAction)onAddPhotoButtonTap:(id)sender;
- (IBAction)beginEditingSelectionFields:(id)sender;
- (IBAction)onCancelButtonTap:(id)sender;
- (IBAction)onSelectButtonTap:(id)sender;

@property (strong, nonatomic) NSArray *itemTypes;
@property (strong, nonatomic) NSArray *seasons;

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemTypes = @[@"Shirt", @"Jacket", @"Dress", @"Skirt", @"Pants", @"Shorts",  @"Shoes"];
    self.seasons = @[@"Spring", @"Summer", @"Fall", @"Winter"];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"selectionScreenSegue"]) {
        SelectorToolViewController *selectorController = [segue destinationViewController];
        if(sender == self.typeButton){
            selectorController.selectionItems = self.itemTypes;
            selectorController.label = self.typeLabel;
        }
        else if(sender == self.seasonButton)
        {
            selectorController.selectionItems = self.seasons;
            selectorController.label = self.seasonLabel;
        }
        selectorController.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        selectorController.modalPresentationStyle = UIModalPresentationCustom;
    }
}

- (IBAction)onSelectButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"selectionScreenSegue" sender:sender];
}

- (IBAction)onCancelButtonTap:(id)sender {
    [self leaveScreen];
}

- (IBAction)beginEditingSelectionFields:(id)sender {
    [self performSegueWithIdentifier:@"selectionScreenSegue" sender:sender];
}

- (IBAction)onAddPhotoButtonTap:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose"
               message:@"How would you like to add a photo?"
        preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a camera action
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                 imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                          }];
        [alert addAction:cameraAction];

        // create a photo libray action
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                         }];
        [alert addAction:photoLibraryAction];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (IBAction)onSaveButtonTap:(id)sender {
    //add saving functionlity
    UIImage *itemImage = [self resizeImage:self.itemImageView.image withSize:CGSizeMake(414, 414)];
    int priceInt = [self.priceTextView.text intValue];
    [Item postItemWithImage:itemImage withDescription:self.descriptionTextView.text withSeason:self.seasonLabel.text withSize:self.sizeTextView.text withType:self.typeLabel.text withPrice:priceInt withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Item is created");
            [self.delegate didAddNewItem];
            [self leaveScreen];
        }
        else{
            NSLog(@"Something went wrong with saving item: %@", error.localizedDescription);
        }
    }];
}
- (void) leaveScreen{
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.itemImageView setImage:originalImage];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
