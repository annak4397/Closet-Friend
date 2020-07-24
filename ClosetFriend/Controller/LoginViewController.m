//
//  LoginViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/13/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SceneDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)onSignUpButtonTap:(id)sender;
- (IBAction)onLoginButtonTap:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLoginButton.backgroundColor = [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.00];
    fbLoginButton.frame = CGRectMake(0, 0, 305, 34);
    fbLoginButton.center = self.view.center;
    [fbLoginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    //fbLoginButton.permissions = @[@"public_profile", @"email"];
    [fbLoginButton addTarget:self action:@selector(fbLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbLoginButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) fbLoginButtonClicked{
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email"] block:^(PFUser *user, NSError *error) {
      if (!user) {
        NSLog(@"Uh oh. The user cancelled the Facebook login.");
      } else if (user.isNew) {
        NSLog(@"User signed up and logged in through Facebook!");
      } else {
        NSLog(@"User logged in through Facebook!");
        SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
          myDelegate.window.rootViewController = navigationController;
      }
    }];
}
- (IBAction)onLoginButtonTap:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (IBAction)onSignUpButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}
@end
