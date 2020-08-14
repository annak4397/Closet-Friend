//
//  AWFForecast.h
//  Aeris
//
//  Created by Nicholas Shipes on 9/6/13.
//  Copyright (c) 2013 AerisWeather, LLC. All rights reserved.
//

#import <AerisWeatherKit/AWFGeographicObject.h>

@class AWFForecastPeriod;

typedef NSDictionary<NSString *, id> *AWFForecastWeatherCodedItem;

/**
 An `AWFForecast` object represents data returned by the [**forecasts** endpoint](https://www.aerisweather.com/support/docs/api/reference/endpoints/forecasts/)
 of the Aeris Weather API.
 */
@interface AWFForecast : AWFGeographicObject

/**
 An array of forecast period returned for this forecast.
 */
@property (nonatomic, strong, nullable) NSArray<AWFForecastPeriod *> *periods;

@end


/**
 An `AWFForecastPeriod` object represents data for a single period returned by the [**forecasts** endpoint](https://www.aerisweather.com/support/docs/api/reference/endpoints/forecasts/)
 of the Aeris Weather API.
 */
@interface AWFForecastPeriod : AWFWeatherObject

/**
 GMT date for the period.
 */
@property (nonatomic, strong, nullable) NSDate *timestamp;

/**
 Local timezone for the forecast period.
 */
@property (nonatomic, strong, nullable) NSTimeZone *timeZone;

/**
 Short primary weather phrase for the period.
 */
@property (nonatomic, copy, nullable) NSString *weather;

/**
 Primary coded weather type for the period.
 */
@property (nonatomic, copy, nullable) NSString *weatherCoded;

/**
 Full weather phrase for the period.
 */
@property (nonatomic, copy, nullable) NSString *weatherFull;

/**
 All coded weather types for the period.
 */
@property (nonatomic, copy, nullable) NSArray<AWFForecastWeatherCodedItem> *weatherFullCoded;

/**
 Sky coverage code.
 */
@property (nonatomic, copy, nullable) NSString *cloudsCoded;

/**
 Sky coverage as a percentage.
 */
@property (nonatomic, assign) CGFloat skyCoverPercentage;

/**
 Weather icon for the primary weather type.
 */
@property (nonatomic, copy, nullable) NSString *icon;

/**
 Forecast temperature for the date specified by `validDate` in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat tempF;

/**
 Forecast temperature for the date specified by 'validDate` in degrees Celsius.
 */
@property (nonatomic, assign) CGFloat tempC;

/**
 Minimum temperature forecasted for the period in degrees Fahrenheit.
*/
@property (nonatomic, assign) CGFloat tempMinF;

/**
 Minimum temperature forecasted for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat tempMinC;

/**
 Maximum temperature forecasted for the period in degrees Fahrenheit.
*/
@property (nonatomic, assign) CGFloat tempMaxF;

/**
 Maximum temperature forecasted for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat tempMaxC;

/**
 Average temperature forecasted for the period in degrees Fahrenheit.
*/
@property (nonatomic, assign) CGFloat tempAvgF;

/**
 Average temperature forecasted for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat tempAvgC;

/**
 Forecast apparent temperature in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat feelslikeF;

/**
 Forecast apparent temperature in degrees Celsius.
 */
@property (nonatomic, assign) CGFloat feelslikeC;

/**
 Minimum apparent temperature forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat feelslikeMinF;

/**
 Minimum apparent temperature forecast for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat feelslikeMinC;

/**
 Maximum apparent temperature forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat feelslikeMaxF;

/**
 Maximum apparent temperature forecast for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat feelslikeMaxC;

/**
 Average apparent temperature forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat feelslikeAvgF;

/**
 Average apparent temperature forecast for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat feelslikeAvgC;

/**
 Forecast dew point forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat dewpointF;

/**
 Forecast dew point forecast for the period in degrees Celsius.
 */
@property (nonatomic, assign) CGFloat dewpointC;

/**
 Minimum dew point forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat dewpointMinF;

/**
 Minimum dew point forecast for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat dewpointMinC;

/**
 Maximum dew point forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat dewpointMaxF;

/**
 Maximum dew point forecast for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat dewpointMaxC;

/**
 Average dew point forecast for the period in degrees Fahrenheit.
 */
@property (nonatomic, assign) CGFloat dewpointAvgF;

/**
 Average dew point forecast for the period in degrees Celcius.
 */
@property (nonatomic, assign) CGFloat dewpointAvgC;

/**
 Relative humidity for the period as a percentage.
 */
@property (nonatomic, assign) CGFloat humidity;

/**
 Minimum relative humidity for the period as a percentage.
 */
@property (nonatomic, assign) CGFloat humidityMin;

/**
 Maximum relative humidity for the period as a percentage.
 */
@property (nonatomic, assign) CGFloat humidityMax;

/**
 Probability of precipitation (POP) for the period as a percentage.
 */
@property (nonatomic, assign) CGFloat pop;

/**
 UV index for the period.
 */
@property (nonatomic, assign) NSInteger uvIndex;

/**
 Forecast forecasted precipitation for the period in inches.
 **/
@property (nonatomic, assign) CGFloat precipIN;

/**
 Forecast precipitation for the period in millimeters.
 */
@property (nonatomic, assign) CGFloat precipMM;

/**
 Forecast ice accumulation for the period in millimeters.
 */
@property (nonatomic, assign) CGFloat iceAccumulationMM;

/**
 Forecast ice accumulation for the period in inches.
 */
@property (nonatomic, assign) CGFloat iceAccumulationIN;

/**
 Forecast snowfall for the period in inches.
 */
@property (nonatomic, assign) CGFloat snowIN;

/**
 Forecast snowfall for the period in centimeters.
 */
@property (nonatomic, assign) CGFloat snowCM;

/**
 Forecast wind speed in knots (KTS).
 */
@property (nonatomic, assign) CGFloat windSpeedKTS;

/**
 Forecast wind speed in miles per hour (MPH).
 */
@property (nonatomic, assign) CGFloat windSpeedMPH;

/**
 Forecast wind speed in kilometers per hour (KMH).
 */
@property (nonatomic, assign) CGFloat windSpeedKMH;

/**
 Forecast minimum wind speed in knots (KTS).
 */
@property (nonatomic, assign) CGFloat windSpeedMinKTS;

/**
 Forecast minimum wind speed in miles per hour (MPH).
 */
@property (nonatomic, assign) CGFloat windSpeedMinMPH;

/**
 Forecast minimum wind speed in kilometers per hour (KMH).
 */
@property (nonatomic, assign) CGFloat windSpeedMinKMH;

/**
 Forecast maximum wind speed in knots (KTS).
 */
@property (nonatomic, assign) CGFloat windSpeedMaxKTS;

/**
 Forecast maximum wind speed in miles per hour (MPH).
 */
@property (nonatomic, assign) CGFloat windSpeedMaxMPH;

/**  Forecast maximum wind speed in kilometers per hour (KMH).
 */
@property (nonatomic, assign) CGFloat windSpeedMaxKMH;

/**
 The wind speed range rounded to the nearest interval of 5 miles per hour above and below the forecasted value.
 */
@property (nonatomic, readonly, nullable) NSString *windSpeedRangeMPH;

/**
 The wind speed range rounded to the nearest interval of 5 kilometers per hour above and below the forecasted value.
 */
@property (nonatomic, readonly, nullable) NSString *windSpeedRangeKMH;

/**
 The wind speed range rounded to the nearest interval of 5 knots per hour above and below the forecasted value.
 */
@property (nonatomic, readonly, nullable) NSString *windSpeedRangeKTS;

/**
 Forecast wind gust speed in knots (KTS).
 */
@property (nonatomic, assign) CGFloat windGustKTS;

/**
 Forecast wind gust speed in miles per hour (MPH).
 */
@property (nonatomic, assign) CGFloat windGustMPH;

/**
 Forecast wind gust speed in kilometers per hour (KMH).
 */
@property (nonatomic, assign) CGFloat windGustKMH;

/**
 Forecast cardinal wind direction (e.g., N, E, S, W).
 */
@property (nonatomic, copy, nullable) NSString *windDirection;

/**
 Forecast wind direction in degrees (0-359, 0=North).
 */
@property (nonatomic, assign) CGFloat windDirectionDEG;

/**
 Cardinal wind direction at the time of the forecasted minimum wind speed.
 */
@property (nonatomic, copy, nullable) NSString *windDirMin;

/**
 Wind direction in degrees at the time of the forecast minimum wind speed.
 */
@property (nonatomic, assign) CGFloat windDirMinDEG;

/**
 Cardinal wind direction at the time of the forecasted maximum wind speed.
 */
@property (nonatomic, copy, nullable) NSString *windDirMax;

/**
 Wind direction in degrees at the time of the forecast maximum wind speed.
 */
@property (nonatomic, assign) CGFloat windDirMaxDEG;

/**
 Forecast cardinal wind direction (e.g., N, E, S, W) at a height of 80 meters.
 */
@property (nonatomic, copy, nullable) NSString *windDir80m;

/**
 Forecast wind direction in degrees (0-359, 0=North) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windDir80mDEG;

/**
 Cardinal wind direction at the time of the forecasted minimum wind speed at a height of 80 meters.
 */
@property (nonatomic, copy, nullable) NSString *windDirMin80m;

/**
 Wind direction in degrees at the time of the forecast minimum wind speed at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windDirMin80mDEG;

/**
 Cardinal wind direction at the time of the forecasted maximum wind speed at a height of 80 meters.
 */
@property (nonatomic, copy, nullable) NSString *windDirMax80m;

/**
 Wind direction in degrees at the time of the forecast maximum wind speed at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windDirMax80mDEG;

/**
 Forecast wind speed in knots (KTS) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeed80mKTS;

/**
 Forecast wind speed in miles per hour (MPH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeed80mMPH;

/**
 Forecast wind speed in kilometers per hour (KMH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeed80mKMH;

/**
 Forecast minimum wind speed in knots (KTS) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeedMin80mKTS;

/**
 Forecast minimum wind speed in miles per hour (MPH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeedMin80mMPH;

/**
 Forecast minimum wind speed in kilometers per hour (KMH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeedMin80mKMH;

/**
 Forecast maximum wind speed in knots (KTS) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeedMax80mKTS;

/**
 Forecast maximum wind speed in miles per hour (MPH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeedMax80mMPH;

/**  Forecast maximum wind speed in kilometers per hour (KMH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windSpeedMax80mKMH;

/**
 Forecast wind gust speed in knots (KTS) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windGust80mKTS;

/**
 Forecast wind gust speed in miles per hour (MPH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windGust80mMPH;

/**
 Forecast wind gust speed in kilometers per hour (KMH) at a height of 80 meters.
 */
@property (nonatomic, assign) CGFloat windGust80mKMH;

/**
 Forecast barometric pressure in inches of mercury.
 */
@property (nonatomic, assign) CGFloat pressureIN;

/**
 Forecast barometric pressure in millibars.
 */
@property (nonatomic, assign) CGFloat pressureMB;

/**
 Forecast visibility for the period in kilometers.
 */
@property (nonatomic, assign) CGFloat visibilityKM;

/**
 Forecast visibility for the period in miles.
 */
@property (nonatomic, assign) CGFloat visibilityMI;

/**
 Estimated forecast solar radiation for the period.
 */
@property (nonatomic, assign) CGFloat solarRadiationWM2;

/**
 Minimum estimated forecast solar radiation for the period.
 */
@property (nonatomic, assign) CGFloat solarRadiationMinWM2;

/**
 Maximum estimated forecast solar radation for the period.
 */
@property (nonatomic, assign) CGFloat solarRadiationMaxWM2;

/**
 GMT date of the sunrise for the period.
 */
@property (nonatomic, strong, nullable) NSDate *sunrise;

/**
 GMT date of the sunset for the period.
 */
@property (nonatomic, strong, nullable) NSDate *sunset;

/**
 Whether or not the period is during the day (between sunrise and sunset times).
 */
@property (nonatomic, assign) BOOL isDay;

/** Deprecated Properties */
@property (nonatomic, assign) CGFloat maxTempF;
@property (nonatomic, assign) CGFloat maxTempC;
@property (nonatomic, assign) CGFloat minTempF;
@property (nonatomic, assign) CGFloat minTempC;
@property (nonatomic, assign) CGFloat avgTempF;
@property (nonatomic, assign) CGFloat avgTempC;

@end
