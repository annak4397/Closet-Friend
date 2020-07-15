//
//  SelectorToolViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 7/14/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "SelectorToolViewController.h"
#import "SceneDelegate.h"

@interface SelectorToolViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *selectionPicker;
- (IBAction)onDoneButtonTap:(id)sender;
- (IBAction)onCancelButtonTap:(id)sender;
@property (weak, nonatomic) NSString *selectedItem;
@end

@implementation SelectorToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.selectionPicker.dataSource = self;
    self.selectionPicker.delegate = self;
    
    self.selectedItem = self.selectionItems[0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    double bottomPadding = myDelegate.window.safeAreaInsets.bottom;
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 700 - self.tabBarHeight, self.view.frame.size.width, 200)];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.selectionItems.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.selectionItems[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedItem = self.selectionItems[row];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onCancelButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onDoneButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate.text = self.selectedItem;
    }];
}
@end
