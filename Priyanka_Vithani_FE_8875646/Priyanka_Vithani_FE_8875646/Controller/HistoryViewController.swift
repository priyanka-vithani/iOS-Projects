//
//  HistoryViewController.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 05/12/23.
//

import UIKit

class HistoryViewController: UIViewController {
    //MARK: Variables & Constants
    var history : [History]?
    
    @IBOutlet weak var tableview: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        tableview.register(UINib(nibName: "DirectionTableViewCell", bundle: nil), forCellReuseIdentifier: "DirectionTableViewCell")
        tableview.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        fetchData()
        self.title = "Search History"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func fetchData(){
        do{
            self.history = try AppConstants.content.fetch(History.fetchRequest())
            DispatchQueue.main.async { self.tableview.reloadData()
            }
        } catch {
            print("no data")
        }
    }
    @objc func newsButtonTapped(sender: UIButton){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
        if let newsVC = vc.viewControllers?[0] as? NewsViewController{
            newsVC.locationName = history?[sender.tag].cityName ?? ""
            newsVC.isFromHistory = true
        }
        vc.selectedIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func weatherButtonTapped(sender: UIButton){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
        if let weatherVC = vc.viewControllers?[2] as? WeatherViewController{
            weatherVC.locationName = history?[sender.tag].cityName ?? ""
            weatherVC.isFromHistory = true
        }
        vc.selectedIndex = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func directionButtonTapped(sender: UIButton){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController else {return}
        if let directionVC = vc.viewControllers?[1] as? MapViewController{
            directionVC.destinationLocationName = history?[sender.tag].cityName ?? ""
            directionVC.isFromHistory = true
            switch history?[sender.tag].travelMethod {
            case "car":
                directionVC.transportType = .car
            case "bike":
                directionVC.transportType = .bike
            case "walk":
                directionVC.transportType = .walk
            default:
                break
            }
        }
        vc.selectedIndex = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch history?[indexPath.row].transactionTo {
        case "News":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else{return UITableViewCell()}
            cell.topView.isHidden = false
            cell.titleLabel.text = history?[indexPath.row].newsTitle ?? ""
            cell.descriptionLabel.text = history?[indexPath.row].newsDescription ?? ""
            cell.autherLabel.text = "Author: \(history?[indexPath.row].newsAuthor ?? "None")"
            cell.sourceLabel.text = "Source: \(history?[indexPath.row].newsSource ?? "None")"
            cell.cityNameLabel.text = "\(history?[indexPath.row].cityName ?? "")"
            cell.fromScreenNameLabel.text = "From \(history?[indexPath.row].typeOfInteraction ?? "")"
            cell.newsButton.tag = indexPath.row
                        cell.newsButton.addTarget(self, action: #selector(newsButtonTapped), for: .touchUpInside)
            return cell
        case "Weather":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else{return UITableViewCell()}
            cell.dateLabel.text = "Date: \(history?[indexPath.row].weatherDate ?? "")"
            cell.timeLabel.text = "Time: \(history?[indexPath.row].weatherTime ?? "")"
            cell.humidityLabel.text = "Humidity: \(history?[indexPath.row].humidity ?? "")"
            cell.windLabel.text = "Wind: \(history?[indexPath.row].wind ?? "")"
            cell.temperatureLabel.text = "Temperature: \(history?[indexPath.row].temperature ?? "")°C"
            cell.cityLabel.text = "\(history?[indexPath.row].cityName ?? "")"
            cell.weatherButton.tag = indexPath.row
            cell.fromScreenNameLabel.text = "From \(history?[indexPath.row].typeOfInteraction ?? "")"
                        cell.weatherButton.addTarget(self, action: #selector(weatherButtonTapped), for: .touchUpInside)
            return cell
        case "Direction":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionTableViewCell", for: indexPath) as? DirectionTableViewCell else{return UITableViewCell()}
            cell.startPoint.text = "start Point: \(history?[indexPath.row].startPoint ?? "")"
            cell.endPoint.text = "End Point: \(history?[indexPath.row].endPoint ?? "")"
            cell.travelMethod.text = "Mode of travel: \(history?[indexPath.row].travelMethod ?? "None")"
            cell.totalDistance.text = "Total Distance: \(history?[indexPath.row].totalDistance ?? "None")"
            cell.cityLabel.text = "\(history?[indexPath.row].cityName ?? "")"
            cell.directionButton.tag = indexPath.row
            cell.fromScreenNameLabel.text = "From \(history?[indexPath.row].typeOfInteraction ?? "")"
                        cell.directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let dataToRemove = self.history![indexPath.row]
            print(dataToRemove)
            AppConstants.content.delete(dataToRemove)

            // save the context
            do {
                try AppConstants.content.save()
            } catch {
                print("Error saving data")
            }

            // remove the data from the array and the table view
            self.history?.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
