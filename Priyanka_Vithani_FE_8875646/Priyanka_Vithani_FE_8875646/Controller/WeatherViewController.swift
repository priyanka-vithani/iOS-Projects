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
    var locationName:String?
    var isFromHistory:Bool = false
    
    //MARK: Outlets
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherIconImageview: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherCondition: UILabel!
    
    //MARK: View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if let location = self.locationName{
            convertAddress(cityName: location)
        }else{
            locationManager.requestLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: IBactions
    @IBAction func homeButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func plusButtonAction(_ sender: Any) {
        showAlert()
    }
    
    //MARK: Methods
    func convertAddress(cityName:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, errors in
            guard let placemark = placemarks else{
                print("location not found")
                let alertController = UIAlertController(title: "Error", message: "Searched location not found to get weather data. So displaying current location weather data", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                self.locationManager.requestLocation()
                return
            }
            if let city = placemark.first?.locality{
                self.callWeatherApi(cityName: city)
                
            } else if let country = placemark.first?.country{
                self.callWeatherApi(cityName: country)
            }
        }
    }
    func showAlert(){
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter your new destination here", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        let goAction = UIAlertAction(title: "Go", style: .default) { (_) in
            if let itemName = alertController.textFields?.first?.text {
                self.locationName = itemName
                self.isFromHistory = false
                self.convertAddress(cityName: self.locationName ?? "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(goAction)
        present(alertController, animated: true, completion: nil)
    }
    func setUI(weatherData: WeatherModel){
       
        self.cityName.text = weatherData.name
        self.temperatureLabel.text = "\(Int(weatherData.main?.temp?.rounded() ?? 0))"
        self.feelsLikeLabel.text = "Feels Like \(Int(weatherData.main?.feelsLike?.rounded() ?? 0))"
        self.weatherCondition.text = weatherData.weather?.first?.description ?? ""
        self.humidityLabel.text = "Humidity: \(weatherData.main?.humidity ?? 0)%"
        self.windLabel.text = "Wind: \((weatherData.wind?.speed?.rounded() ?? 0) * 3.6) km/h"
    }
    
    func saveDataToCoreData(cityName:String, weatherData:WeatherModel){
        let history = History(context: AppConstants.content)
        history.typeOfInteraction = cityName == self.locationName ? "Home" : "Weather"
        history.cityName = weatherData.name
        history.transactionTo = "Weather"
        history.temperature = "\(Int(weatherData.main?.temp?.rounded() ?? 0))"
        history.humidity = "\(weatherData.main?.humidity ?? 0)%"
        history.wind = "\((weatherData.wind?.speed?.rounded() ?? 0) * 3.6) km/h"
        history.weatherDate = self.getDate()
        history.weatherTime = self.getTime()
        // Save the data
        do {
            try AppConstants.content.save()
        } catch {
            print("Error saving data")
        }
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
                    self.cityName.text = city
                }
                if let country = placemark.isoCountryCode{
                    locationtext = locationtext != "" ? locationtext + ", \(country)" : country
                }
                if let countrycode = placemark.postalCode{
                    locationtext = locationtext != "" ? locationtext + ", \(countrycode)" : countrycode
                }
                self.callWeatherApi(cityName: placemark.locality ?? "")
            }
        }
    }
    func getDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        // Convert the string to a Date object
        if let date = dateFormatter.date(from: "6 December 2023") {
            // Format the date as "6 December 2023"
            let formattedDate = dateFormatter.string(from: date)
            
            return formattedDate
        }
        return ""
    }
    
    func getTime() -> String{
        // Create a date formatter
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        // Convert the string to a Date object
        if let date = timeFormatter.date(from: "8:48 PM") {
            // Format the date as "8:48 PM"
            let formattedTime = timeFormatter.string(from: date)
            
            return formattedTime
        }
        return ""
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

//MARK: Call API
extension WeatherViewController{
    func callWeatherApi(cityName:String){
        let urlStr = "\(ApiConstants.baseWeatherURL)&q=\(cityName)"
        let urlSession = URLSession(configuration:.default)
        let url = URL(string: urlStr)
        if let url = url{
            let _: Void = urlSession.dataTask(with: url){ (data, response, error) in
                if let data = data{
                    print(data)
                    if let weatherData = try? JSONDecoder().decode(WeatherModel.self, from: data){
                        if let iconUrlStr = URL(string: "\(ApiConstants.iconWeatherURL)\(String(describing: weatherData.weather?.first?.icon ?? "")).png"){
                            let icondata = try? Data(contentsOf: iconUrlStr)
                            if let imageData = icondata {
                                DispatchQueue.main.async {
                                    self.weatherIconImageview.image = UIImage(data: imageData)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.setUI(weatherData: weatherData)
                        }
                        if !self.isFromHistory{
                            self.saveDataToCoreData(cityName: cityName, weatherData: weatherData)
                        }
                    }
                }
            }.resume()
        }
    }
}
