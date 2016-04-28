//
//  Weather.swift
//  SuperApplication
//
//  Created by Филипп Белов on 4/27/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit
import SwiftyJSON

class Weather: NSObject {
    var temp: Double?
    var tempeCelsius: Double? {
        return (temp!-32)*5/9
    }
    var maxTemp: Double?
    var minTemp: Double?
    var wShortDesc: String?
    var wDesc: String?
    var place: Place?
    
    init (temperature newTemp: Double, place newPlace: Place, maxTemp: Double, minTemp: Double, wShortDesc: String, wDesc: String) {
        self.temp = newTemp
        self.place = newPlace
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.wShortDesc = wShortDesc
        self.wDesc = wDesc
        
        super.init()
        
    }
    
    // convenience initializer to initialize the Weather object more conviniently :)
    convenience init? (data: NSData) {
        let jsonData = JSON(data: data)
                
        // using guard contstruction to prevent cases when we by some reason got 'incorrect' json data
        guard let place = Place(data: data) else { return nil }
        guard let temp = jsonData["main"]["temp"].double else { return nil }
        guard let maxTemp = jsonData["main"]["temp_max"].double else { return nil }
        guard let minTemp = jsonData["main"]["temp_min"].double else  { return nil }
        guard let wShortDesc = jsonData["weather"][0]["main"].string else { return nil }
        guard let wDesc = jsonData["weather"][0]["description"].string else { return nil }
        
        self.init(temperature: temp, place: place, maxTemp: maxTemp, minTemp: minTemp, wShortDesc: wShortDesc, wDesc: wDesc)
        
    }
}
