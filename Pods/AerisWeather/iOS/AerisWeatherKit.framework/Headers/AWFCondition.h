//
//  AWFCondition.h
//  AerisWeatherKit
//
//  Created by Nicholas Shipes on 5/20/20.
//  Copyright © 2020 AerisWeather, LLC. All rights reserved.
//

#import <AerisWeatherKit/AWFGeographicObject.h>

NS_ASSUME_NONNULL_BEGIN

@class AWFConditionPeriod;

/**
 An `AWFCondition` object represents data returned by the [**conditions** endpoint](https://www.aerisweather.com/support/docs/api/reference/endpoints/conditions/)
 of the AerisWeather API.
 */
@interface AWFCondition : AWFGeographicObject

/**
 An array of condition periods for the location.
 */
@property (nonatomic, strong, nullable) NSArray<AWFConditionPeriod *> *periods;

@end


/**
 An `AWFConditionPeriod` object represents data for a single period returned by the [**conditions** endpoint](https://www.aerisweather.com/support/docs/api/reference/endpoints/conditions/)
 of the AerisWeather API.
 */
@interface AWFConditionPeriod : AWFWeatherObject

/**
 GMT Date of the observation.
 */
@property (nonatomic, strong, nullable) NSDate *timestamp;

/**
 Local timezone for the period.
 */
@property (nonatomic, strong, nullable) NSTimeZone *timeZone;

//-----------------------------------------------------------------------------
// @name Weather & Clouds
//-----------------------------------------------------------------------------

/**
 Primary weather phrase.
 */
@property (nonatomic, copy, nullable) NSString *weather;

/**
 Coded weather for the primary weather observed.
 
 The coded weather values can often be used for translating the weather observed. Refer to the [Weather Codes](https://www.aerisweather.com/support/docs/api/reference/weather-codes/)
 API documentation for additional information.
 */
@property (nonatomic, copy, nullable) NSString *weatherCoded;

/**
 Full weather phrase.
 */
@property (nonatomic, copy, nullable) NSString *weatherFull;

/**
 Full set of weather codes for the weather.
 */
@property (nonatomic, copy, nullable) NSString *weatherFullCoded;

/**
 Weather icon representing the weather from the default icon set.
 */
@property (nonatomic, copy, nullable) NSString *icon;

/**
 Sky coverage code.
 */
@property (nonatomic, copy, nullable) NSString *cloudsCoded;

/**
 Percentage of the sky covered by clouds. A value of `0` indicates clear sky conditions, while a value of `100` indicates entirely overcast sky
 conditions.
 */
@property (nonatomic, assign) CGFloat skyCoverPercentage;

//-----------------------------------------------------------------------------
// @name Temperatures
//-----------------------------------------------------------------------------

/**
 Temperature in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat tempF;

/**
 Temperature in degrees Celsius.
 */
@property (nonatomic, assign) CGFloat tempC;

/**
 Apparent temperature in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat feelslikeF;

/**
 Apparent temperature in degrees Celsius.
 */
@property (nonatomic, assign) CGFloat feelslikeC;

/**
 Dew point temperature in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat dewpointF;

/**
 Dew point temperature in degrees Celsius.
 */
@property (nonatomic, assign) CGFloat dewpointC;

//-----------------------------------------------------------------------------
// @name Relative Humidity
//-----------------------------------------------------------------------------

/**
 Calculated relative humidity as a percentage.
 */
@property (nonatomic, assign) CGFloat humidity;

//-----------------------------------------------------------------------------
// @name Winds
//-----------------------------------------------------------------------------

/**
 Cardinal wind direction.
 */
@property (nonatomic, copy, nullable) NSString *windDirection;

/**
 Wind direction in degrees (0=North).
 */
@property (nonatomic, assign) CGFloat windDirectionDEG;

/**
 Wind speed in knots.
 */
@property (nonatomic, assign) CGFloat windSpeedKTS;

/**
 Wind speed in miles per hour.
 */
@property (nonatomic, assign) CGFloat windSpeedMPH;

/**
 Wind speed in kilometers per hour.
 */
@property (nonatomic, assign) CGFloat windSpeedKMH;

/**
 Wind gust speed in knots.
 */
@property (nonatomic, assign) CGFloat windGustKTS;

/**
 Wind gust speed in miles per hour.
 */
@property (nonatomic, assign) CGFloat windGustMPH;

/**
 Wind gust speed in kilometers per hour.
 */
@property (nonatomic, assign) CGFloat windGustKMH;

//-----------------------------------------------------------------------------
// @name Barometric Pressure
//-----------------------------------------------------------------------------

/**
 Mean sea level pressure (MSLP) in inches of mercury.
 */
@property (nonatomic, assign) CGFloat pressureIN;

/**
 Mean sea level pressure (MSLP) in millibars.
 */
@property (nonatomic, assign) CGFloat pressureMB;

//-----------------------------------------------------------------------------
// @name Visibility
//-----------------------------------------------------------------------------

/**
 Visibility in kilometers.
 */
@property (nonatomic, assign) CGFloat visibilityKM;

/**
 Visibility in miles.
 */
@property (nonatomic, assign) CGFloat visibilityMI;

//-----------------------------------------------------------------------------
// @name Precipitation
//-----------------------------------------------------------------------------

/**
 Estimated amount of precipitation in inches.
 */
@property (nonatomic, assign) CGFloat precipIN;

/**
 Estimated amount of precipitation in millimeters.
 */
@property (nonatomic, assign) CGFloat precipMM;

/**
 Estimated amount of snowfall for the period in inches.
 */
@property (nonatomic, assign) CGFloat snowIN;

/**
 Estimated amount of snowfall for the period in centimeters.
 */
@property (nonatomic, assign) CGFloat snowCM;

//-----------------------------------------------------------------------------
// @name Other
//-----------------------------------------------------------------------------

/**
 UV index for the period.
*/
@property (nonatomic, assign) CGFloat uvIndex;

/**
 Solar radiation in watts per square meter.
 */
@property (nonatomic, assign) CGFloat solarRadiationWM2;

/**
 Whether or not the period occurred during daylight hours based on sunrise and sunset times.
 */
@property (nonatomic, assign) BOOL isDay;

@end

NS_ASSUME_NONNULL_END
