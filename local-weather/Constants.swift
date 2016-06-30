//
//  Constants.swift
//  local-weather
//
//  Created by Daniel Ray on 6/4/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import Foundation
import UIKit

var zip = "91335"
let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
var QUERY = "?zip=\(zip),us"
let KEY = "&appid=b5236561caa15422f9db74ec2905bc4f"
typealias DownloadComplete = () -> ()
var formatter = NSDateFormatter()
var locale = "en_US_POSIX"
let TIMEZONE_PACIFIC_US = "US/Pacific"
let SHADOW_COLOR:CGFloat = 157.0 / 255.0

//Reuse Identifiers
let REUSE_ID_CITY_CELL = "CityCell"

let KEY_CITY_INFO = "cityInfo"




