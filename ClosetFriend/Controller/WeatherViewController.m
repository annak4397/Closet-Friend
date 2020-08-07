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

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AWFForecast *forcast;
@property (weak, nonatomic) IBOutlet UIButton *degreeButton;
- (IBAction)onDegreeButtonTap:(id)sender;
@property BOOL isCelsius;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isCelsius = true;
    
    [self loadWeatherData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.forcast.periods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherTableViewCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCell" forIndexPath:indexPath];
    AWFForecastPeriod *period = self.forcast.periods[indexPath.row];
    [weatherCell createWeatherCell:self.isCelsius withPeriod:period];

    return weatherCell;
}
- (void) loadWeatherData{
    AWFPlace *place = [AWFPlace placeWithCity:@"seattle" state:@"wa" country:@"us"];
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
@end
