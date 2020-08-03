//
//  WeatherTableViewCell.m
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 8/3/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "WeatherTableViewCell.h"
@import AerisWeatherKit;

@implementation WeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) createWeatherCell: (BOOL) celsius withPeriod: (AWFForecastPeriod *) period {
    self.period = period;
    self.WeatherIcon.image = [UIImage imageNamed:period.icon];
    self.WeatherType.text = period.weather;
    self.humidityPercent.text = [@"Humidity: %" stringByAppendingFormat:[NSString stringWithFormat:@"%.0f", period.humidity]];
    //self.Date.text = period.
    self.lowTemp.textColor = [UIColor blueColor];
    self.highTemp.textColor = [UIColor redColor];
    if(celsius){
        self.TempFeelsLike.text = [[NSString stringWithFormat:@"%.0f", period.feelslikeC] stringByAppendingFormat:@"°C"];
        self.lowTemp.text = [[NSString stringWithFormat:@"%.0f", period.tempMinC] stringByAppendingFormat: @"°C"];
        self.highTemp.text = [[NSString stringWithFormat:@"%.0f", period.tempMaxC] stringByAppendingFormat: @"°C"];
    }
    else{
        self.TempFeelsLike.text = [[NSString stringWithFormat:@"%.0f", period.feelslikeF] stringByAppendingFormat:@"°F"];
        self.lowTemp.text = [[NSString stringWithFormat:@"%.0f", period.tempMinF] stringByAppendingFormat: @"°F"];
        self.highTemp.text = [[NSString stringWithFormat:@"%.0f", period.tempMaxF] stringByAppendingFormat: @"°F"];
    }
}

@end
