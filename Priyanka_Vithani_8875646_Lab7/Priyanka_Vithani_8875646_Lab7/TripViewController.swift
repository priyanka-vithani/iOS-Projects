//
//  TripViewController.swift
//  Priyanka_Vithani_8875646_Lab7
//
//  Created by Priyanka Vithani on 11/11/23.
//

import UIKit
import MapKit
import CoreLocation

class TripViewController: UIViewController {
    //MARK: Variables
    var locationManager = CLLocationManager()
    var startTime: Date?
    var startLocation: CLLocation?
    var maxSpeed: CLLocationSpeed = 0
    var totalDistance: CLLocationDistance = 0
    var maxAcceleration: Double = 0
    var driverAnnotation: MKPointAnnotation?
    var isSpeedExceeded: Bool = false
    
    //MARK: Outlets
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distenceLabel: UILabel!
    @IBOutlet weak var maxAccelerationLabel: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    //MARK: Actions
    @IBAction func startTripButton(_ sender: UIButton) {
        startTrip()
    }
    
    @IBAction func stopTripButton(_ sender: UIButton) {
        stopTrip()
    }
    
    //MARK: Methods
    func startTrip() {
        startTime = Date()
        startLocation = nil
        maxSpeed = 0
        totalDistance = 0
        maxAcceleration = 0
        locationManager.startUpdatingLocation()
        greenView.backgroundColor = .green
    }
    func stopTrip() {
        locationManager.stopUpdatingLocation()
        greenView.backgroundColor = .gray
    }
    func calculateDistanceBeforeExceedingSpeedLimit(currentSpeed: Double) {
        let timeToExceedLimit = (currentSpeed / maxSpeed) * maxAcceleration
        let distance = 0.5 * maxAcceleration * timeToExceedLimit * timeToExceedLimit
        let strDist = String(format: "%.2f", distance)
        self.distanceLabel.text = "\(strDist) km/h"
    }
    func render(loc location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
    }
    func calculateKilometersBeforeExceedingLimit() -> Double? {
        guard maxSpeed > 0 else {
            return nil
        }
        
        let timeToExceedLimit = (115 / 3.6 - maxSpeed) / maxAcceleration
        let distance = 0.5 * maxAcceleration * timeToExceedLimit * timeToExceedLimit
        
        return distance
    }
    func updateMapView(with location: CLLocation) {
        let coordinate = location.coordinate
        
        // Update the map view with the new location
        mapView.setCenter(coordinate, animated: true)
        
        // Optionally, you can zoom in to the driver's location by setting a region
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Add a map annotation for the driver's location
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    func calculateTotalDistance(location: CLLocation){
        // Calculate distance
        let distance = location.distance(from: startLocation!)
        totalDistance += distance
    }
    
    func calculateSpeed(location: CLLocation, speed: CLLocationSpeed){
        
        // Check if speed exceeds 115 km/h
        if speed > 115 / 3.6 {
            redView.backgroundColor = .red
        }
        let strSpeed = String(format: "%.2f", speed * 3.6)
        currentSpeedLabel.text = "\(strSpeed) km/h"
        
    }
    func calculateAcceleration(location: CLLocation, speed: CLLocationSpeed){
        // Calculate acceleration
        let acceleration = (speed - startLocation!.speed) / location.timestamp.timeIntervalSince(startLocation!.timestamp)
        maxAcceleration = max(maxAcceleration, abs(acceleration))
    }
    func calculateMaxSpeed(speed:CLLocationSpeed){
        let strAcc = String(format: "%.2f", maxAcceleration)
        maxAccelerationLabel.text = "\(strAcc) m/s^2"
        // Update max speed
        maxSpeed = max(maxSpeed, speed)
        let strMaxSpeed = String(format: "%.2f", maxSpeed * 3.6)
        maxSpeedLabel.text = "\(strMaxSpeed) km/h"
    }
    func updateAvgSpeed(location: CLLocation){
        // Update average speed
        let elapsedTime = location.timestamp.timeIntervalSince(startTime!)
        let avgSpeed = totalDistance / elapsedTime
        let strAvgSpeed = String(format: "%.2f", avgSpeed * 3.6)
        averageSpeedLabel.text = "\(strAvgSpeed) km/h"
    }
    func updateDistance(speed: CLLocationSpeed){
        // Update distance
        let strTotalDistancw = String(format: "%.2f", totalDistance/1000)
        distanceLabel.text = "\(strTotalDistancw) km"
        // Check if speed exceeds 115 km/h
        if speed > 115 / 3.6 {
            redView.backgroundColor = .red
            if !isSpeedExceeded{
                messageLabel.text = "The driver travel \(strTotalDistancw) km before exceeding the speed limit of 115 km/h"
            }
            isSpeedExceeded = true
            
        }
    }
    func updateMapView(location: CLLocation){
        // Update map view
        mapView.setCenter(location.coordinate, animated: true)
        if driverAnnotation == nil {
            // Create a new annotation if it doesn't exist
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            driverAnnotation = annotation
        } else {
            // Update the existing annotation with the new location
            driverAnnotation?.coordinate = location.coordinate
        }
        
        // Optionally, you can zoom in to the driver's location by setting a region
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}
//MARK: CLLocationManagerDelegate
extension TripViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        if startLocation == nil {
            startLocation = currentLocation
        }
        
        calculateTotalDistance(location: currentLocation)
        // Calculate speed
        let speed = currentLocation.speed
        calculateSpeed(location: currentLocation, speed: speed)
        calculateAcceleration(location: currentLocation, speed: speed)
        calculateMaxSpeed(speed: speed)
        
        updateAvgSpeed(location: currentLocation)
        updateDistance(speed: speed)
        
        updateMapView(location: currentLocation)
        // Update start location for the next iteration
        startLocation = currentLocation
    }
}
