//
//  WeatherViewController.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 8/3/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherTableViewCell.h"
@import AerisWeatherKit;
@import SCLAlertView_Objective_C;

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AWFForecast *forcast;
@property (weak, nonatomic) IBOutlet UIButton *degreeButton;
- (IBAction)onDegreeButtonTap:(id)sender;
@property BOOL isCelsius;
@property (strong , nonatomic) NSMutableArray *daysOfTheWeek;
@property (weak, nonatomic) UITextField *cityField;
@property (weak, nonatomic) UITextField *stateField;
- (IBAction)onLocationButtonTap:(id)sender;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isCelsius = true;
    
    NSDate *day = [[NSDate alloc] init];
    int weekStart = (int)day.awf_weekday;
    self.daysOfTheWeek = [[NSMutableArray alloc] init];
    for(int i = weekStart; i < weekStart + 8; i++){
        switch (i % 8) {
            case 1:
                [self.daysOfTheWeek addObject:@"Sunday"];
                break;
            case 2:
                [self.daysOfTheWeek addObject:@"Monday"];
                break;
            case 3:
                [self.daysOfTheWeek addObject:@"Tuesday"];
                break;
            case 4:
                [self.daysOfTheWeek addObject:@"Wednesday"];
                break;
            case 5:
                [self.daysOfTheWeek addObject:@"Thursday"];
                break;
            case 6:
                [self.daysOfTheWeek addObject:@"Friday"];
                break;
            case 7:
                [self.daysOfTheWeek addObject:@"Saturday"];
                break;
        }
    }
    
    [self loadWeatherData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.forcast.periods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherTableViewCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCell" forIndexPath:indexPath];
    AWFForecastPeriod *period = self.forcast.periods[indexPath.row];
    [weatherCell createWeatherCell:self.isCelsius withPeriod:period withDay: self.daysOfTheWeek[indexPath.row]];

    return weatherCell;
}
- (void) loadWeatherData{
    AWFPlace *place;
    if(self.cityField == nil || self.stateField == nil){
        place = [AWFPlace placeWithCity:@"seattle" state:@"wa" country:@"us"];
    }
    else{
        NSString *city = [self.cityField.text lowercaseString];
        NSString *state = [self.stateField.text lowercaseString];
        place = [AWFPlace placeWithCity:city state:state country:@"us"];
    }
    
    AWFWeatherRequestOptions *options = [AWFWeatherRequestOptions new];
    options.limit = 7;

    [[AWFForecasts sharedService] getForPlace:place options:options completion:^(AWFWeatherEndpointResult * _Nullable result) {
        if (result.error) {
            NSLog(@"Data failed to load! - %@", result.error.localizedDescription);
            return;
        }
        else{
            self.forcast = (AWFForecast *)[result.results firstObject];
            [self.tableView reloadData];
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

- (IBAction)onDegreeButtonTap:(id)sender {
    self.isCelsius = !self.isCelsius;
    [self.tableView reloadData];
}
- (IBAction)onLocationButtonTap:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];

    self.cityField = [alert addTextField:@"Enter City"];
    self.stateField = [alert addTextField:@"Enter State"];
    
    [alert addButton:@"Enter" actionBlock:^(void) {
        NSLog(@"Text value: %@ %@", self.cityField.text, self.stateField.text);
        [self loadWeatherData];
    }];

    [alert showEdit:self title:@"Enter Location" subTitle:@"Enter the City,State to get the weather location." closeButtonTitle:nil duration:0.0f];
}
@end
