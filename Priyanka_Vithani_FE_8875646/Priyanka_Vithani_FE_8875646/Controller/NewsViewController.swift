//
//  NewsViewController.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 02/12/23.
//

import UIKit
import CoreLocation
class NewsViewController: UIViewController {
    
    //MARK: Variables
    var locationManager = CLLocationManager()
    var locationName:String?
    var newsData: NewsModel?
    var isFromHistory:Bool = false
    
    //MARK: IBOutlets
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if let location = self.locationName, location != ""{
            convertAddress(cityName: location)
        }else{
            locationManager.requestLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    //MARK: IBActions
    @IBAction func homeButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func plusButtonAction(_ sender: Any) {
        showAlert()
    }
    
    //MARK: Methods
    func showAlert(){
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter your new destination here", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        let goAction = UIAlertAction(title: "Go", style: .default) { (_) in
            if let itemName = alertController.textFields?.first?.text, itemName != "" {
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
    func saveToCoreData(location:String){
        let history = History(context: AppConstants.content)
        history.typeOfInteraction = "Home"
        history.cityName = location
        history.transactionTo = "News"
        history.newsTitle = self.newsData?.articles?.first?.title ?? ""
        history.newsDescription = self.newsData?.articles?.first?.description ?? ""
        history.newsSource = self.newsData?.articles?.first?.source?.name ?? "None"
        history.newsAuthor = self.newsData?.articles?.first?.author ?? "None"
        
        do {
            try AppConstants.content.save()
        } catch {
            print("Error saving data")
        }
    }
    func convertAddress(cityName:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, errors in
            guard let placemark = placemarks, let location = placemark.first?.locality else{
                print("location not found")
                let alertController = UIAlertController(title: "Error", message: "Please enter valid city name to get the news", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let strUrl = "\(ApiConstants.newsApi)&q=\(location)"
            
            self.fetchDataFromURL(urlString: strUrl) { result in
                switch result {
                case .success(let news):
                    self.newsData = news
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                    if !self.isFromHistory{
                        self.saveToCoreData(location: location)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    func fetchDataFromURL(urlString: String, completion: @escaping (Result<NewsModel, Error>) -> Void){
        // Create a URL object
        if let url = URL(string: urlString) {
            // Create a URLSession task
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Check for errors
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Check if data is available
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                // Parse the JSON data
                do {
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print(JSONString)
                    }
                    
                    let welcome = try JSONDecoder().decode(NewsModel.self, from: data)
                    
                    completion(.success(welcome))
                } catch {
                    completion(.failure(error))
                }
            }
            // Start the URLSession task
            task.resume()
        }
    }
}
//MARK: CLLocationManagerDelegate
extension NewsViewController: CLLocationManagerDelegate{
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
                let strUrl = "\(ApiConstants.newsApi)&q=\(placemark.locality ?? "")"
                self.fetchDataFromURL(urlString: strUrl) { result in
                    switch result {
                    case .success(let success):
                        self.newsData = success
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                        if !self.isFromHistory{
                            self.saveToCoreData(location: placemark.locality ?? "")
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//MARK: Tableview Methods
extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.newsData?.articles?.count ?? 0) == 0){
            tableView.setEmptyMessage("No news available as per given city name")
        }else{
            tableView.restore()
        }
        return self.newsData?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else{return UITableViewCell()}
        cell.contentView.backgroundColor = .white
        cell.titleLabel.text = self.newsData?.articles?[indexPath.row].title ?? ""
        cell.descriptionLabel.text = self.newsData?.articles?[indexPath.row].description  ?? ""
        cell.autherLabel.text = "Author: \(self.newsData?.articles?[indexPath.row].author ?? "None")"
        cell.sourceLabel.text = "Source: \(self.newsData?.articles?[indexPath.row].source?.name ?? "None")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
