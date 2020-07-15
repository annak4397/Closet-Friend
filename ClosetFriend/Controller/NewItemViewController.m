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
@import Parse;

@interface NewItemViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextView;
@property (weak, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextField *seasonTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTypeTextField;
- (IBAction)onSaveButtonTap:(id)sender;
- (IBAction)onAddPhotoButtonTap:(id)sender;
- (IBAction)beginEditingSelectionFields:(id)sender;
- (IBAction)onCancelButtonTap:(id)sender;

@property (strong, nonatomic) NSArray *itemTypes;
@property (strong, nonatomic) NSArray *seasons;

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //MainPageController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.delegate = [storyboard instantiateViewControllerWithIdentifier:@"MainPageController"];
    
    self.itemTypes = @[@"shirt", @"pants", @"shoes", @"skirt"];
    self.seasons = @[@"Winter", @"Spring", @"Summer", @"Fall"];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"selectionScreenSegue"]) {
        SelectorToolViewController *selectorController = [segue destinationViewController];
        if(sender == self.itemTypeTextField){
            selectorController.selectionItems = self.itemTypes;
        }
        else if(sender == self.seasonTextField)
        {
            selectorController.selectionItems = self.seasons;
        }
        selectorController.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        selectorController.delegate = sender;
        selectorController.modalPresentationStyle = UIModalPresentationCustom;
    }
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
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)onSaveButtonTap:(id)sender {
    //add saving functionlity
    UIImage *itemImage = [self resizeImage:self.itemImageView.image withSize:CGSizeMake(414, 414)];
    NSNumber *priceNumb = @([self.priceTextView.text floatValue]);
    [Item postItemWithImage:itemImage withDescription:self.descriptionTextView.text withSeason:self.seasonTextField.text withSize:self.sizeTextView.text withType:self.itemTypeTextField.text withPrice:priceNumb withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Item is created");
            
            [self leaveScreen];
            
            [self.delegate didCreateNewItem];
        }
        else{
            NSLog(@"Something went wrong with saving item: %@", error.localizedDescription);
        }
    }];
}
- (void) leaveScreen{
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    myDelegate.window.rootViewController = navigationController;
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
