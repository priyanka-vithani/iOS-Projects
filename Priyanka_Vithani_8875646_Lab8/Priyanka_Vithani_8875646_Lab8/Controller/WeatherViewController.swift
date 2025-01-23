//
//  WeatherViewController.swift
//  Priyanka_Vithani_8875646_Lab8
//
//  Created by Priyanka Vithani on 19/11/23.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    //MARK: Variables
    let locationManager = CLLocationManager()
    
    //MARK: Outlets
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var weatherIconImageview: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var FeelsLike: UILabel!
    @IBOutlet weak var weatherCondition: UILabel!
    
    //MARK: View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up location manager
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    //MARK: Actions
    @IBAction func GetCurrentLocationAction(_ sender: Any) {
        locationManager.requestLocation()
    }
    @IBAction func searchAction(_ sender: Any) {
        self.view.endEditing(true)
    }
}
// MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Reverse geocode the location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                // Access location name, city, etc. from placemark
                var locationtext = ""
                if let city = placemark.locality{
                    locationtext = city
                }
                if let country = placemark.isoCountryCode{
                    locationtext = locationtext != "" ? locationtext + ", \(country)" : country
                }
                if let countrycode = placemark.postalCode{
                    locationtext = locationtext != "" ? locationtext + ", \(countrycode)" : countrycode
                }
                self.searchTextField.text = locationtext
                self.callWeatherApi(cityName: placemark.locality ?? "")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

//MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func btnSearch_clk(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""{
            return true
        }else{
            searchTextField.placeholder = "Type Something here.."
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            self.callWeatherApi(cityName: city)
        }
    }
}

//MARK: Call API
extension WeatherViewController{
    func callWeatherApi(cityName:String){
        let urlStr = "\(ApiConstants.baseURL)&q=\(cityName)"
        let urlSession = URLSession(configuration:.default)
        let url = URL(string: urlStr)
        if let url = url{
            let _: Void = urlSession.dataTask(with: url){ (data, response, error) in
                if let data = data{
                    print(data)
                    let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
                    if let iconUrlStr = URL(string: "\(ApiConstants.iconURL)\(String(describing: weatherData?.weather?.first?.icon ?? ""))@2x.png"){
                        let icondata = try? Data(contentsOf: iconUrlStr)

                        DispatchQueue.main.async {
                            self.temperatureLabel.text = "\(Int(weatherData?.main?.temp?.rounded() ?? 0))"
                            self.FeelsLike.text = "Feels Like \(Int(weatherData?.main?.feelsLike?.rounded() ?? 0))"
                            self.weatherCondition.text = weatherData?.weather?.first?.description ?? ""
                            if let imageData = icondata {
                                self.weatherIconImageview.image = UIImage(data: imageData)
                            }
                            self.humidity.text = "Humidity: \(weatherData?.main?.humidity ?? 0)%"
                            self.wind.text = "Wind: \((weatherData?.wind?.speed?.rounded() ?? 0) * 3.6) km/h"
                        }
                    }
                }
            }.resume()
        }
    }
}
