//
//  ViewController.swift
//  local-weather
//
//  Created by Daniel Ray on 6/4/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var timedBackgroundImg: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeZoneLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    var laWeather = CityWeather()
    var musicPlayer: AVAudioPlayer!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        laWeather.loadCityWeather { 
            // This will be run after download complete
            print("\(self.laWeather.cityName) Weather")
            self.cityLbl.text = "\(self.laWeather.cityName) Weather"
            self.descriptionLbl.text = self.laWeather.weather_desc.capitalizedString
            
            self.temperatureLbl.text = "\(round(self.laWeather.temperature))ºF"
            let text = self.laWeather.weatherIcon as NSString
            let char = text.characterAtIndex(text.length - 1)
            if char == 110 {
                self.timedBackgroundImg.image = UIImage(named: "NBG")
            } else {
                self.timedBackgroundImg.image = UIImage(named: "DBG")
            }
            self.weatherIconImg.image = UIImage(named: self.laWeather.weatherIcon)
            
            let currentDay = self.getfromDate(self.laWeather.currentTime, formatter: formatter, locale: "en_US_POSIX", timeZone: "US/Pacific", format: "EEEE")
            let currentDate = self.getfromDate(self.laWeather.currentTime, formatter: formatter, locale: "en_US_POSIX", timeZone: "US/Pacific", format: "MM/dd/yyy")
            let lastUpdateTime = self.getfromDate(self.laWeather.currentTime, formatter: formatter, locale: "en_US_POSIX", timeZone: "US/Pacific", format: "h:mm a")
            let timeZone = self.getfromDate(self.laWeather.currentTime, formatter: formatter, locale: "en_US_POSIX", timeZone: "US/Pacific", format: "zz")
            let sunrise = self.getfromDate(self.laWeather.sunrise, formatter: formatter, locale: "en_US_POSIX", timeZone: "US/Pacific", format: "h:mm a")
            let sunset = self.getfromDate(self.laWeather.sunset, formatter: formatter, locale: "en_US_POSIX", timeZone: "US/Pacific", format: "h:mm a")
            
            print(currentDay)
            self.dayLbl.text = currentDay
            print(currentDate)
            self.dateLbl.text = currentDate
            print(lastUpdateTime)
            self.timeLbl.text = "\(lastUpdateTime) \(timeZone)"
            print(timeZone)
            self.sunriseLbl.text = sunrise
            print(sunrise)
            self.sunsetLbl.text = sunset
            print(sunset)
            
            self.musicInit("hcts", type: "mp3")
                
            
            
        }
        
    }
    
    func musicInit(name: String, type: String) {
        
        let musicPath = NSBundle.mainBundle().pathForResource(name, ofType: type)
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: musicPath!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }

        
    }
    
    func getfromDate(date: NSDate, formatter: NSDateFormatter, locale: String, timeZone: String, format: String) -> String {
        if let tz  = NSTimeZone(name: timeZone) {
            formatter.timeZone = tz
        } else {
            formatter.timeZone = NSTimeZone(name: "US/Pacific")
        }
        
        if format == "EEEE" || format == "MM/dd/yyy" || format == "h:mm a" || format == "zz" {
            formatter.dateFormat = format
            formatter.locale = NSLocale(localeIdentifier: locale)
            return formatter.stringFromDate(date)
        } else {
            return "invalid"
        }
        
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.3
        } else {
            musicPlayer.play()
            sender.alpha = 0.7
        }
    }




}

