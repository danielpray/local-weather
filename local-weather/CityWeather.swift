//
//  CityWeather.swift
//  local-weather
//
//  Created by Daniel Ray on 6/4/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import Foundation
import Alamofire

class CityWeather {
    private var _cityName: String!
    private var _currentTime: NSDate?
    private var _weather_desc: String?
    private var _temperature: Float?
    private var _weatherID: Int?
    private var _weatherIcon: String?
    private var _sunrise: NSDate?
    private var _sunset: NSDate?
    private var _country: String?
    private var _zipCode: String!
    
    var cityName: String {
        get {
            if _cityName == nil {
                return ""
            }
            return _cityName
        }
    }
    
    var currentTime: NSDate {
        get {
            if _currentTime != nil {
                return _currentTime!
            } else {
                return NSDate()
            }
        }
        
    }
    
    var weather_desc: String {
        get {
            if _weather_desc == nil {
                return ""
            }
            return _weather_desc!
        }
    }
    
    var temperature: Float {
        get {
            if _temperature == nil {
                return -1.0
            }
            return _temperature!
        }
    }
    
    var weatherID: Int {
        get {
            if _weatherID == nil {
                return -1
            }
            return _weatherID!
        }
    }
    
    var weatherIcon: String {
        get {
            if _weatherIcon == nil {
                return ""
            }
            return _weatherIcon!
        }
    }
    
    var sunrise: NSDate {
        get {
            if _sunrise == nil {
                return NSDate()
            } else {
                return _sunrise!
            }
        }
        
    }
    
    var sunset: NSDate {
        get {
            if _sunset == nil {
                return NSDate()
            } else {
                return _sunset!
            }
        }
    }
    
    var country: String {
        get {
            if _country == nil {
                return ""
            }
            return _country!
        }
    }
    
    var zipCode: String {
        return _zipCode
    }
    
    init(city: City) {
        _zipCode = city.zipCode
        _cityName = city.name
        
    }
    
    func loadCityWeather(completed: DownloadComplete) {
        
        
        let query = "?zip=\(_zipCode),us"
        let url = "\(BASE_URL)\(query)\(KEY)"
        let nsurl = NSURL(string: url)!
        
        Alamofire.request(.GET, nsurl).responseJSON { response in
            let result = response.result
            print(result.debugDescription)
            if let dict = result.value as? Dictionary<String,AnyObject> {
                //if let city = dict["name"] as? String {
                //    print(city)
                //    self._cityName = city
                //}
                if let main_dict = dict["main"] as? Dictionary<String,AnyObject> {
                    // print(main_dict.debugDescription)
                    if let temperature = main_dict["temp"] as? Float {
                        let tempertureF = ((temperature - 273.15) * 1.8) + 32.0
                        print (tempertureF)
                        self._temperature = tempertureF
                        
                    }
                }
                if let weather_dict = dict["weather"] as? [Dictionary<String,AnyObject>] {
                    print(weather_dict[0].debugDescription)
                    if let icon = weather_dict[0]["icon"] as? String {
                        print(icon)
                        self._weatherIcon = icon
                    }
                    if let weather_desc = weather_dict[0]["description"] as? String {
                        print(weather_desc.capitalizedString)
                        self._weather_desc = weather_desc
                    }
                    if let weather_id = weather_dict[0]["id"] as? Int {
                        print(weather_id)
                        self._weatherID = weather_id
                    }
                }
                
                if let sys_dict = dict["sys"] as? Dictionary<String,AnyObject> {
                    print(sys_dict.debugDescription)
                    if let country = sys_dict["country"] as? String {
                        print(country)
                        self._country = country
                        
                    }
                    if let sunrise = sys_dict["sunrise"] as? NSTimeInterval {
                        print(sunrise)
                        self._sunrise = NSDate(timeIntervalSince1970: sunrise)
                    }
                    if let sunset = sys_dict["sunset"] as? NSTimeInterval {
                        print(sunset)
                        self._sunset = NSDate(timeIntervalSince1970: sunset)
                    }
                }
                
                if let dt = dict["dt"] as? NSTimeInterval {
                    
                    print(dt)
                    self._currentTime = NSDate(timeIntervalSince1970: dt)
                    
                }
                
                completed()
            
            }
        
        }

        
       
        
    }
    
}
