//
//  MapViewController.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 02/12/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    //MARK: Variables
    var locationManager = CLLocationManager()
    var sourceLocation: CLLocation?
    var destinationLocation: CLLocation?
    var driverAnnotation: MKPointAnnotation?
    var isFromHistory:Bool = false
    enum TransportationType:String{
        case car
        case bike
        case walk
    }
    var transportType:TransportationType = .car
    var isFromHome:Bool = false
    var destinationLocationName:String?
    var sourceLocationName:String?
    var destinationPin: MKPointAnnotation?
    var currentRoute: MKRoute?
    
    //MARK: IBOutlet
    @IBOutlet weak var sliderControl: UISlider!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if destinationLocationName != nil{
            isFromHome = true
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        print(destinationLocationName ?? "Not defined")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if destinationLocationName == nil{
            showAlert()
        }else{
            self.convertAddress()
        }
    }
    
    //MARK: IBActions
    @IBAction func carButtonAction(_ sender: UIButton) {
        self.transportType = .car
        self.mapThis()
        selectbutton(button: sender)
        deselectButton(button: bikeButton)
        deselectButton(button: walkButton)
    }
    @IBAction func bikeButtonAction(_ sender: UIButton) {
        self.transportType = .bike
        self.mapThis()
        selectbutton(button: sender)
        deselectButton(button: walkButton)
        deselectButton(button: carButton)
    }
    @IBAction func walkButtonAction(_ sender: UIButton) {
        self.transportType = .walk
        self.mapThis()
        selectbutton(button: sender)
        deselectButton(button: bikeButton)
        deselectButton(button: carButton)
        
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        setZoomLevel(value: sender.value)
    }
    @IBAction func homeButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func plusButtonAction(_ sender: Any) {
        showAlert()
    }
    
    //MARK: Methods
    func selectbutton(button:UIButton){
        button.backgroundColor = .green
        button.tintColor = .black
    }
    func deselectButton(button:UIButton){
        button.backgroundColor = .systemGray5
        button.tintColor = .systemBlue
    }
    func storeDataIntoCoreData(){
        let history = History(context: AppConstants.content)
        history.typeOfInteraction = isFromHome ? "Home" : "Map"
        history.cityName = self.destinationLocationName
        history.transactionTo = "Direction"
        history.startPoint = self.sourceLocationName
        history.endPoint = self.destinationLocationName
        history.travelMethod = self.transportType.rawValue
        if let start = self.sourceLocation, let end = self.destinationLocation{
            let distance = String(format: "%.2f", (start.distance(from: end))/1000)
            history.totalDistance = "\(distance) km"
        }
        // Save the data
        do {
            try AppConstants.content.save()
        } catch {
            print("Error saving data")
        }
    }
    func showAlert(){
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter your new destination here", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        let goAction = UIAlertAction(title: "Go", style: .default) { (_) in
            if let itemName = alertController.textFields?.first?.text {
                print(itemName)
                self.destinationLocationName = itemName
                self.isFromHistory = false
                self.convertAddress()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(goAction)
        present(alertController, animated: true, completion: nil)
    }
    func showErrorAlert(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func setZoomLevel(value:Float){
        let currentZoomlevel = mapView.camera.centerCoordinateDistance
        print(value)
        let zoomLevel = value * 10
        //        print(zoomLevel)
        // Set the map's camera zoom level
        let camera = MKMapCamera(lookingAtCenter: self.sourceLocation?.coordinate ?? mapView.centerCoordinate, fromDistance: mapView.camera.altitude, pitch: mapView.camera.pitch, heading: mapView.camera.heading)
        camera.altitude = pow(2, Double(zoomLevel)) * 1000
        mapView.setCamera(camera, animated: false)
    }
    func convertAddress(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destinationLocationName ?? "") { placemarks, errors in
            guard let placemark = placemarks, let location = placemark.first?.location else{
                print("location not found")
                self.showErrorAlert(message: "Destination location not found")
                return
            }
            guard let sLocation = self.locationManager.location else { return  }
            self.sourceLocation = sLocation
            self.destinationLocation = location
            
            self.mapThis()
            switch self.transportType {
            case .car:
                self.selectbutton(button: self.carButton)
            case .bike:
                self.selectbutton(button: self.bikeButton)
            case .walk:
                self.selectbutton(button: self.walkButton)
            }
            
        }
    }
    func mapThis(){
        guard let sLocation = self.sourceLocation else { return  }
        guard let dLocation = self.destinationLocation else { return  }
        
        let dPlacemark = MKPlacemark(coordinate: dLocation.coordinate)
        let sPlacemark = MKPlacemark(coordinate: sLocation.coordinate)
        
        let dItem = MKMapItem(placemark: dPlacemark)
        let sItem = MKMapItem(placemark: sPlacemark)
        
        let dRequest = MKDirections.Request()
        
        dRequest.source = sItem
        dRequest.destination = dItem
        switch transportType {
        case .car:
            dRequest.transportType = .automobile
        case .bike:
            dRequest.transportType = .automobile
        case .walk:
            dRequest.transportType = .walking
        }
        dRequest.requestsAlternateRoutes = true
        let direction = MKDirections(request: dRequest)
        direction.calculate { resp, error in
            guard let response = resp else{
                if let err = error  {
                    print(err)
                    self.showErrorAlert(message: err.localizedDescription)
                }
                return
            }
            // draw route
            guard let route = response.routes.first else{return}
            if let oldRoute = self.currentRoute {
                self.mapView.removeOverlay(oldRoute.polyline)
            }
            self.currentRoute = route
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)

            // add annotation
            if let oldDestinationPin = self.destinationPin {
                self.mapView.removeAnnotation(oldDestinationPin)
            }
            self.destinationPin = self.addAnnotation(coordinate: dLocation.coordinate, title: "End Point")
            if !self.isFromHistory{
                self.storeDataIntoCoreData()
            }
        }
    }
    func addAnnotation(coordinate:CLLocationCoordinate2D, title:String)-> MKPointAnnotation{
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        mapView.addAnnotation(pin)
        return pin
    }
}
//MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.sourceLocation = location
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding failed with error: \(error.localizedDescription)")
                    self.showErrorAlert(message: error.localizedDescription)
                    return
                }
                if let placemark = placemarks?.first {
                    // Access the location name from the placemark
                    if let locationName = placemark.name {
                        self.sourceLocationName = locationName
                    } else {
                        // If the name is not available, you can use other components like locality, subLocality, etc.
                        print("Current location name: \(placemark.locality ?? "")")
                    }
                }
            }
            _ = self.addAnnotation(coordinate: location.coordinate, title: "Start Point")
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
            self.setZoomLevel(value: self.sliderControl.value)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showErrorAlert(message: error.localizedDescription)
    }
}
//MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeline = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        routeline.strokeColor = .blue
        return routeline
    }
}
