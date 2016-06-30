//
//  City.swift
//  local-weather
//
//  Created by Daniel Ray on 6/30/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import Foundation

class City {
    
    var _name: String!
    var _zipCode: String!
    var _stateLong: String!
    var _stateShort: String!
    var _county: String!
    var _lattitude: String!
    var _longitude: String!
    
    
    var name: String {
        return _name
    }
    
    var zipCode: String {
        return _zipCode
    }
    
    var stateLong: String {
        return _stateLong
    }
    
    var stateShort: String {
        return _stateShort
    }
    
    var county: String {
        return _county
    }
    
    var lattitude: String {
        return _lattitude
    }
    
    var longitude: String {
        return _longitude
    }
    
    var searchString: String {
        return "\(_name), \(_stateShort) \(_zipCode)"
    }
    
    init() {
        
        let cityInfo = NSUserDefaults.standardUserDefaults().objectForKey(KEY_CITY_INFO) as? [String]

        if cityInfo == nil {
            _name = "Reseda"
            _zipCode = "91335"
            _stateLong = "California"
            _stateShort = "CA"
            _county = "Los Angeles"
            _lattitude = "34.2007"
            _longitude = "118.5391"
        } else {
            _name = cityInfo![0]
            _zipCode = cityInfo![1]
            _stateLong = cityInfo![2]
            _stateShort = cityInfo![3]
            _county = cityInfo![4]
            _lattitude = cityInfo![5]
            _longitude = cityInfo![6]

        }
    }
    
    init(cityRow: Dictionary<String,String>) {
        if let name = cityRow["Place Name"] {
            _name = name
        } else {
            _name = ""
        }
        if let zipCode = cityRow["Postal Code"] {
            _zipCode = zipCode
        }else {
            _zipCode = ""
        }
        if let stateLong = cityRow["State"] {
            _stateLong = stateLong
        }else {
            _stateLong = ""
        }
        if let stateShort = cityRow["State Abbreviation"] {
            _stateShort = stateShort
        } else {
            _stateShort = ""
        }
        if let county = cityRow["County"] {
            _county = county
        } else {
            _county = ""
        }
        if let lat = cityRow["Lattitude"], let lon = cityRow["Longitude"] {
            _lattitude = lat
            _longitude = lon
        } else {
            _lattitude = ""
            _longitude = ""
        }
    }
}

