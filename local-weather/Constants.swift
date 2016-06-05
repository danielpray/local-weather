//
//  Constants.swift
//  local-weather
//
//  Created by Daniel Ray on 6/4/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
let QUERY = "?q=Losangeles,us"
let KEY = "&appid=b5236561caa15422f9db74ec2905bc4f"
typealias DownloadComplete = () -> ()
var formatter = NSDateFormatter()
var locale = "en_US_POSIX"




