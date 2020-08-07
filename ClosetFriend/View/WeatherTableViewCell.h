//
//  WeatherTableViewCell.h
//  ClosetFriend
//
//  Created by Anna Kuznetsova on 8/3/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AerisWeatherKit;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *WeatherType;
@property (weak, nonatomic) IBOutlet UILabel *TempFeelsLike;
@property (weak, nonatomic) IBOutlet UILabel *lowTemp;
@property (weak, nonatomic) IBOutlet UILabel *highTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidityPercent;
@property (strong, nonatomic) AWFForecastPeriod *period;

- (void) createWeatherCell: (BOOL) celsius withPeriod: (AWFForecastPeriod *) period withDay: (NSString *) dayOfTheWeek;
@end

NS_ASSUME_NONNULL_END
