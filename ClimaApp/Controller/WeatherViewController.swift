//
//  ViewController.swift
//  ClimaApp
//
//  Created by Jimit Shah on 1/16/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
  
  //Constants
  let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
  let APP_ID = "1b3b610f426c50a7f5409ca63cfc8cf7"
  let UNITS = "imperial"
  
  //Declare instance variables here
  let locationManager = CLLocationManager()
  let weatherDataModel = WeatherDataModel()
  
  
  //Pre-linked IBOutlets
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Set up the location manager here.
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  //MARK: - Networking
  /***************************************************************/
  
  //Write the getWeatherData method here:
  func getWeatherData(url: String, parameters: [String:String]) {
    
    Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
      if response.result.isSuccess {
        print("Success! Got the weather data")
        
        let weatherJSON: JSON = JSON(response.result.value!)
        self.updateWeatherData(json: weatherJSON)
        
      } else {
        if let error = response.result.error {
          print("Error \(error)")
        }
        self.cityLabel.text = "Connection Issues"
      }
    }
  }
  
  
  //MARK: - JSON Parsing
  /***************************************************************/
  
  
  //Write the updateWeatherData method here:
  func updateWeatherData(json: JSON) {
    
    if let tempResult = json["main"]["temp"].double {
      //weatherDataModel.temprature = Int((tempResult * 9/5) - 459.67) // substract 459.67 to convert Kelvin -> Fahrenheit
      weatherDataModel.temprature = Int(tempResult)
      weatherDataModel.city = json["name"].stringValue
      weatherDataModel.condition = json["weather"][0]["id"].intValue
      weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
      
      updateUIWithWeatherData()
    } else {
      cityLabel.text = "Weather Unavailable"
    }
  }
  
  
  //MARK: - UI Updates
  /***************************************************************/
  
  
  //Write the updateUIWithWeatherData method here:
  
  func updateUIWithWeatherData() {
    cityLabel.text = weatherDataModel.city
    temperatureLabel.text = "\(weatherDataModel.temprature)"
    weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
  }
  
  
  
  
  
  //MARK: - Location Manager Delegate Methods
  /***************************************************************/
  
  
  //the didUpdateLocations method here:
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      locationManager.delegate = nil
      
      print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
      
      let latitude = String(location.coordinate.latitude)
      let longitude = String(location.coordinate.longitude)
      
      let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID, "units" : UNITS]
      
      getWeatherData(url: WEATHER_URL, parameters: params)
    }
  }
  
  
  //the didFailWithError method here:
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    cityLabel.text = "Location Unavailable"
  }
  
  
  
  
  //MARK: - Change City Delegate methods
  /***************************************************************/
  
  
  //Write the userEnteredANewCityName Delegate method here:
  
  
  
  //Write the PrepareForSegue Method here
  
  
  
  
  
}


