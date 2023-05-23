//
//  ViewController.swift
//  Weather-1980243
//
//  Created by SIVA SUBRAMANIAN PARI ARIVAZHAGAN on 5/22/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var activityView: UIImageView!
    
    let apikey="4360704a909b235cbd2a1172701a8c6d"
    var latitudeVar = 112.344533
    var longitudeVar = 104.33322
    let locMan = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locMan.requestWhenInUseAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()){
            locMan.delegate = self
            locMan.desiredAccuracy = kCLLocationAccuracyBest
            locMan.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        latitudeVar = loc.coordinate.latitude
        longitudeVar = loc.coordinate.longitude
        
        //print("hello1");
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=\(latitudeVar)&lon=\(longitudeVar)&appid=\(apikey)&units=metric").responseJSON {
            
            //print("hello2");
            
            response in
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                print(iconName)
                
                //print("hello3");
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                //print(locationLabel)
                self.tempLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"+"°C"
                
                /*switch iconName {
                case "01d","01n","02d","02n":
                    let ImageVar = UIImage(systemName: "figure.run")
                    self.activityView.image = ImageVar
                case "03d","03n","04d","04n":
                    let ImageVar = UIImage(systemName: "figure.outdoor.cycle")
                    self.activityView.image = ImageVar
                    
                case "09d","09n","10d","10n","11d","11n":
                    let ImageVar = UIImage(systemName: "figure.dance")
                    self.activityView.image = ImageVar
                
                default:
                    let ImageVar = UIImage(systemName: "figure.snowboarding")
                    self.activityView.image = ImageVar
                } */
                
                //print(tempLabel)
                let sunny = ["01d","01n","02d","02n"]
                let cloudy = ["03d","03n","04d","04n"]
                let rainy = ["09d","09n","10d","10n","11d","11n"]
                let snowy = ["13d","13n","50d","50n"]
                
                if sunny.contains(iconName){
                    let ImageVar = UIImage(systemName: "sun.max")
                    self.activityView.image = ImageVar
                }
                
                if cloudy.contains(iconName){
                    let ImageVar = UIImage(systemName: "cloud.fill")
                    self.activityView.image = ImageVar
                    
                }
                
                if rainy.contains(iconName){
                    let ImageVar = UIImage(systemName: "umbrella.fill")
                    self.activityView.image = ImageVar
                    
                }
                
                if snowy.contains(iconName){
                    let ImageVar = UIImage(systemName: "cloud.snow")
                    self.activityView.image = ImageVar
                }
                
            }
        }
    }
}

