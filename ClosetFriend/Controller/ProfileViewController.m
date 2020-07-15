//
//  ProfileViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/15/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "ProfileViewController.h"
@import Parse;
#import "Item.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)onUpdatePhotoButtonTap:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
    self.usernameLabel.text = PFUser.currentUser[@"username"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onUpdatePhotoButtonTap:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose"
               message:@"How would you like to add a photo?"
        preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a camera action
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                            style:UIAlertActionStyleCancel
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    UIImage *profileImage = [self resizeImage:originalImage withSize:CGSizeMake(414, 414)];
    [self.profileImageView setImage:profileImage];
    
    PFUser *current = [PFUser currentUser];
    current[@"profileImage"] = [Item getPFFileFromImage:profileImage];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"saved");
        }
        else{
            NSLog(@"didn't save: %@", error.localizedDescription);
        }
    }];
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
