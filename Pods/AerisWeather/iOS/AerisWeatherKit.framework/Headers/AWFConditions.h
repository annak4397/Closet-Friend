//
//  AWFConditionsEndpoint.h
//  AerisWeatherKit
//
//  Created by Nicholas Shipes on 5/20/20.
//  Copyright © 2020 AerisWeather, LLC. All rights reserved.
//

#import <AerisWeatherKit/AWFWeatherEndpoint.h>

NS_ASSUME_NONNULL_BEGIN

/**
`AWFConditions` provides convenience methods for interacting with the
[`conditions` endpoint](https://www.aerisweather.com/support/docs/api/reference/endpoints/conditions) of the
Aeris API. In most cases, all requests will return instances of `AWFCondition` that will be populated by the data returned by the API unless
otherwise indicated.
*/
@interface AWFConditions : AWFWeatherEndpoint

@end

NS_ASSUME_NONNULL_END
