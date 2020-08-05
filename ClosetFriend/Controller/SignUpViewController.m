//
//  SignUpViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/23/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "SignUpViewController.h"
@import Parse;
@import SCLAlertView_Objective_C;

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)onSignUpButtonTap:(id)sender;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onSignUpButtonTap:(id)sender {
    PFUser *newUser = [PFUser user];
       
       // set user properties
       newUser.username = self.usernameTextField.text;
       newUser.password = self.passwordTextField.text;
       
       // call sign up function on the object
       [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
           if (error != nil) {
               SCLAlertView *alert = [[SCLAlertView alloc] init];
               [alert showError:self title:@"Sign Up Error" subTitle: error.localizedDescription closeButtonTitle:@"Try again." duration:0.0f];
               NSLog(@"Error: %@", error.localizedDescription);
           } else {
               NSLog(@"User registered successfully");
               [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
           }
       }];
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
