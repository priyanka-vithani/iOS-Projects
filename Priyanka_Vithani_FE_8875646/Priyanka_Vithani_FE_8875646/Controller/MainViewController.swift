//
//  MainViewController.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 01/12/23.
//

import UIKit
import MapKit
class MainViewController: UIViewController {
    
    //MARK: Variables
    var locationManager = CLLocationManager()
    var cityName:String?
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View Life Cycle Mtethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My final"
        fetchDataFromCoreData()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: IBActions
    @IBAction func historyButtonAction(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func newsButtonAction(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
        vc.selectedIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func directionButtonAction(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
        vc.selectedIndex = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func weatherButtonAction(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
        vc.selectedIndex = 2
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func alertButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Where you would like to go", message: "Enter your destination", preferredStyle: .alert)
        
        alertController.addTextField()
        let newsAction = UIAlertAction(title: "News", style: .default){ _ in
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
            guard let destination = alertController.textFields?.first?.text, !destination.isEmpty else {
                // Show error message if the text field is empty
                self.showErrorMessage()
                return
            }
            if let newsVC = vc.viewControllers?[0] as? NewsViewController{
                newsVC.locationName = alertController.textFields?.first?.text
            }
            vc.selectedIndex = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let directionAction = UIAlertAction(title: "Direction", style: .default){ _ in
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
            guard let destination = alertController.textFields?.first?.text, !destination.isEmpty else {
                // Show error message if the text field is empty
                self.showErrorMessage()
                return
            }
            if let weatherVC = vc.viewControllers?[1] as? MapViewController{
                weatherVC.destinationLocationName = alertController.textFields?.first?.text
            }
            vc.selectedIndex = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let weatherAction = UIAlertAction(title: "Weather", style: .default){ _ in
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
            guard let destination = alertController.textFields?.first?.text, !destination.isEmpty else {
                // Show error message if the text field is empty
                self.showErrorMessage()
                return
            }
            if let weatherVC = vc.viewControllers?[2] as? WeatherViewController{
                weatherVC.locationName = alertController.textFields?.first?.text
            }
            vc.selectedIndex = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //        alertController.addAction(addAction)
        alertController.addAction(newsAction)
        alertController.addAction(directionAction)
        alertController.addAction(weatherAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Methods
    
    // Function to show error message
    func showErrorMessage() {
        let errorAlert = UIAlertController(title: "Error", message: "Destion can not be empty", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
}

//MARK: CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
}
//MARK: CoreData operations
extension MainViewController{
    func fetchDataFromCoreData(){
        do{
            let data = try AppConstants.content.fetch(History.fetchRequest())
            if data.count <= 0{
                saveDefaultData()
            }
        } catch {
            print("no data")
        }
    }
    func saveDefaultData(){
        let history1 = History(context: AppConstants.content)
        history1.typeOfInteraction = "Home"
        history1.cityName = "Brampton"
        history1.transactionTo = "News"
        history1.newsTitle = "Matt Petgrave and Adam Johnson’s Fatal Mid-Game Ice Hockey Collision Has a Wide Impact"
        history1.newsDescription = "American player Adam Johnson died after his neck was cut by a skate blade during a mid-game collision with opponent Matt Petgrave in Sheffield, England on Oct. 28."
        history1.newsSource = "Time"
        history1.newsAuthor = "Mallory Moench"
        
        let history2 = History(context: AppConstants.content)
        history2.typeOfInteraction = "Home"
        history2.cityName = "Toronto"
        history2.transactionTo = "Weather"
        history2.temperature = "-3"
        history2.humidity = "76%"
        history2.wind = "7.2km/h"
        history2.weatherDate = "6 December 2023"
        history2.weatherTime = "8:35 PM"
        
        let history3 = History(context: AppConstants.content)
        history3.typeOfInteraction = "Map"
        history3.cityName = "Kitchener"
        history3.transactionTo = "Direction"
        history3.startPoint = "Conestga college"
        history3.endPoint = "Fairview Mall"
        history3.travelMethod = "Car"
        history3.totalDistance = "13.8km"
        
        let history4 = History(context: AppConstants.content)
        history4.typeOfInteraction = "Weather"
        history4.cityName = "Milton"
        history4.transactionTo = "Weather"
        history4.temperature = "5"
        history4.humidity = "70%"
        history4.wind = "10.8km/h"
        history4.weatherDate = "6 December 2023"
        history4.weatherTime = "8:48 PM"
        
        let history5 = History(context: AppConstants.content)
        history5.typeOfInteraction = "News"
        history5.cityName = "Hamilton"
        history5.transactionTo = "News"
        history5.newsTitle = "Brazilian City Enacts an Ordinance That Was Secretly Written By ChatGPT"
        history5.newsDescription = "An anonymous reader quotes a report from the Associated Press: City lawmakers in Brazil have enacted what appears to be the nation's first legislation written entirely by artificial intelligence -- even if they didn't know it at the time. The experimental ord…"
        history5.newsSource = "Slashdot.org"
        history5.newsAuthor = "BeauHD"
        
        // Save the data
        do {
            try AppConstants.content.save()
        } catch {
            print("Error saving data")
        }
    }
}
