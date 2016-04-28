//
//  Place.swift
//  SuperApplication
//
//  Created by Филипп Белов on 4/27/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit
import SwiftyJSON

class Place: NSObject {
    var requestURL: NSURL!
    
    var longitude: Double?
    var latitude: Double?
    var city: String?
    var country: String?
    weak var weather: Weather?
    
    init(longitude newLongitude: Double, latitude newLatitude: Double, city newCity: String, country newCountry: String) {
        
        self.longitude = newLongitude
        self.latitude = newLatitude
        self.city = newCity
        self.country = newCountry
        
        super.init()
        
    }
    
    convenience init? (data: NSData) {
        let jsonData = JSON(data: data)
                
        // using guard contstruction to prevent cases when we by some reason got 'incorrect' json data
        guard let longitude = jsonData["coord"]["lon"].double else { return nil }
        guard let latitude = jsonData["coord"]["lat"].double else { return nil }
        guard let city = jsonData["name"].string else { return nil }
        guard let country = jsonData["sys"]["country"].string else { return nil }
        
        self.init(longitude: longitude, latitude: latitude, city: city, country: country)
        
    }
    
    override var description : String {
        return  "city : \(city) "
        + "country : \(country)"
        + "\nlongitude : \(longitude) "
        + "latitude: \(latitude)"
    }

}
