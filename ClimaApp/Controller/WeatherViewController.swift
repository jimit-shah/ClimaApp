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
  //let APP_ID = "e72ca729af228beabd5d20e3b7749713"
  let APP_ID = "1b3b610f426c50a7f5409ca63cfc8cf7"
  
  
  //Declare instance variables here
  let locationManager = CLLocationManager()
  
  
  
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
    let tempResult = json["main"]["temp"]
  }
  
  
  
  
  //MARK: - UI Updates
  /***************************************************************/
  
  
  //Write the updateUIWithWeatherData method here:
  
  
  
  
  
  
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
      
      let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
      
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


