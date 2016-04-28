//
//  WeatherAPI.swift
//  SuperApplication
//
//  Created by Филипп Белов on 4/28/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

public enum TemperatureUnits: String {
    case Celsius = "metric"
    case Fahrenheit = "imperial"
    case Kelvin = ""
}

// I've decided to use Singleton pattern because if we'd built a larger application, for example, with multiple view controllers, or multiple places where we'd needed to perform API calls, it'd come in handy
class WeatherAPI: NSObject {
    
    private var parameters = [String : AnyObject]()

    class var sharedInstance : WeatherAPI {
        
        struct Singleton {
            static let instance = WeatherAPI()
        }
        
        return Singleton.instance
    }
    
    override init () {
        // MARK: OpenWeatherMap API Key
        // Set your OpenWeatherMap API key here
        parameters["APIKEY"] = "988919d090e0428a74323cea4c3ce922"
        // Set units to Farehnheit
        parameters["units"] = TemperatureUnits.Fahrenheit.rawValue
        super.init()
    }
    
    func getCurrentWeatherForLocation(location: CLLocation, completion: (weather : Weather?) -> Void) {
        
        parameters["lat"] = String(stringInterpolationSegment: location.coordinate.latitude)
        parameters["lon"] = String(stringInterpolationSegment: location.coordinate.longitude)
        
        Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather", parameters: parameters)
            .responseJSON { response in
                
                // Check the case when the error is not nil, and try to get info about it
                if response.result.error != nil {
                    print(response.response)
                    completion(weather: nil)
                // If the weather data we got from the request is not nil we need to pass a newly instantiated Weather object to completion block in order to update weather
                } else if let data = response.data {
                    let newWeather = Weather(data: data)
                    completion(weather: newWeather)
                }
                
        }

    }
    
}

