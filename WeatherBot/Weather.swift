//
//  Weather.swift
//  WeatherBot
//
//  Created by Devan on 09/04/18.
//  Copyright © 2018 Perleybrook Labs LLC. All rights reserved.
//

import Foundation

class Weather {
    var temp: String?
    var text: String?
    static func weatherFromJSON(weatherObject: NSDictionary)->Weather {
        let weatherResult = ((((weatherObject["query"] as! NSDictionary)["results"] as! NSDictionary)["channel"] as! NSDictionary)["item"] as! NSDictionary)["condition"] as! NSDictionary
        let weather = Weather()
        weather.text = weatherResult["text"] as? String
        weather.temp = weatherResult["temp"] as? String
        return weather
    }
}
