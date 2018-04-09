//
//  WeatherManager.swift
//  WeatherBot
//
//  Created by Devan on 09/04/18.
//  Copyright © 2018 Perleybrook Labs LLC. All rights reserved.
//

import Foundation

class WeatherManager {
    static let instance: WeatherManager = WeatherManager()
    var weather = Weather()
    private init () {
    }
    func loadWeatherFromCity(city: String, completion: @escaping (Weather) -> Void ) {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(encodedCity!)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                   let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    let weather = Weather.weatherFromJSON(weatherObject: jsonData as! NSDictionary)
                    completion(weather)
                } catch {
                    print ("Error When downloading weather data")
                }
            }
        }.resume()
    }
}
