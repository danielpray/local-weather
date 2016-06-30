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

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var timedBackgroundImg: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
//    @IBOutlet weak var timeZoneLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var containerViewForTable: UIView!
    
    var cityWeather: CityWeather!
    var musicPlayer: AVAudioPlayer!
    
    var cities = [City]()
    var filteredCities = [City]()
    var inSearchMode = false
    var currentCity: City!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        filteredCities = []
        cities = []
        
        
        parseCitiesCSV()
        
       currentCity = City()
        
        
        
        cityWeather = CityWeather(city: currentCity)
        
        cityWeather.loadCityWeather {
            // This will be run after download complete

            self.updateUI()
            
//            self.musicInit("hcts", type: "mp3")
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredCities.count
        } else {
            return cities.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cityCell = tableView.dequeueReusableCellWithIdentifier(REUSE_ID_CITY_CELL) as? CityCell {
            
            if inSearchMode {
                cityCell.configureCityCell(filteredCities[indexPath.row])
            } else {
                cityCell.configureCityCell(cities[indexPath.row])
            }
            return cityCell
        } else {
           return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if inSearchMode {
            currentCity = filteredCities[indexPath.row]
        } else {
            currentCity = cities[indexPath.row]
        }
        
        searchBar.text = ""
        searchBar.endEditing(true)
        containerViewForTable.hidden = true
        cityWeather = CityWeather(city: currentCity)
        cityWeather.loadCityWeather { 
            self.updateUI()
        }
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
            containerViewForTable.hidden = true
        } else {
            containerViewForTable.hidden = false
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredCities = cities.filter({$0.searchString.lowercaseString.rangeOfString(lower) != nil})
            tableView.reloadData()
        }
    }
    
//    func musicInit(name: String, type: String) {
//        
//        let musicPath = NSBundle.mainBundle().pathForResource(name, ofType: type)
//        
//        do {
//            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: musicPath!)!)
//            musicPlayer.prepareToPlay()
//            musicPlayer.numberOfLoops = -1
//            // musicPlayer.play()
//            
//        } catch let err as NSError {
//            print(err.debugDescription)
//        }
//
    
//      }
    
    func parseCitiesCSV() {
        let path = NSBundle.mainBundle().pathForResource("city", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let cty = City(cityRow: row)
                cities.append(cty)
                print(cty.name)
            }
            
        }
        catch let err as NSError {
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
    
    func updateUI() {
        print("\(self.cityWeather.cityName) Weather")
        self.cityLbl.text = "\(self.cityWeather.cityName) Weather"
        self.descriptionLbl.text = self.cityWeather.weather_desc.capitalizedString
        
        self.temperatureLbl.text = "\(round(self.cityWeather.temperature))ºF"
        let text = self.cityWeather.weatherIcon as NSString
        let char = text.characterAtIndex(text.length - 1)
        if char == 110 {
            self.timedBackgroundImg.image = UIImage(named: "NBG")
        } else {
            self.timedBackgroundImg.image = UIImage(named: "DBG")
        }
        self.weatherIconImg.image = UIImage(named: self.cityWeather.weatherIcon)
        
        let currentDay = self.getfromDate(self.cityWeather.currentTime, formatter: formatter, locale: locale, timeZone: TIMEZONE_PACIFIC_US, format: "EEEE")
        let currentDate = self.getfromDate(self.cityWeather.currentTime, formatter: formatter, locale: locale, timeZone: TIMEZONE_PACIFIC_US, format: "MM/dd/yyy")
        let lastUpdateTime = self.getfromDate(self.cityWeather.currentTime, formatter: formatter, locale: locale, timeZone: TIMEZONE_PACIFIC_US, format: "h:mm a")
        let timeZone = self.getfromDate(self.cityWeather.currentTime, formatter: formatter, locale: locale, timeZone: TIMEZONE_PACIFIC_US, format: "zz")
        let sunrise = self.getfromDate(self.cityWeather.sunrise, formatter: formatter, locale: locale, timeZone: TIMEZONE_PACIFIC_US, format: "h:mm a")
        let sunset = self.getfromDate(self.cityWeather.sunset, formatter: formatter, locale: "en_US_POSIX", timeZone: TIMEZONE_PACIFIC_US, format: "h:mm a")
        
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
        
        let cityInfo = [currentCity.name, currentCity.zipCode, currentCity.stateLong, currentCity.stateShort, currentCity.county, currentCity.lattitude, currentCity.longitude]
        
        NSUserDefaults.standardUserDefaults().setValue(cityInfo, forKey: KEY_CITY_INFO)

    }
    
//    @IBAction func musicBtnPressed(sender: UIButton) {
//        if musicPlayer.playing {
//            musicPlayer.stop()
//            sender.alpha = 0.3
//        } else {
//            musicPlayer.play()
//            sender.alpha = 0.7
//        }
//    }
//
//


}

