//
//  GoogleMapViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 11/02/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let storeLatitude: Double = PersistenceStorage.sharedInstance.storeAddressLatitude ?? 40.730610
    let storeLongitude: Double = PersistenceStorage.sharedInstance.storeAddressLongitude ?? -73.935242
    var destinations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 17.452938, longitude: 78.380981), // Destination 1
        CLLocationCoordinate2D(latitude: 17.496602, longitude: 78.367925), // Destination 2
        CLLocationCoordinate2D(latitude: 17.476824, longitude: 78.421963)  // Destination 3
    ]
    var isfromHome : Bool = false
    var orderData : Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize map
        self.nextBtn.isHidden = isfromHome
        if !isfromHome {
            let latitude = orderData?.address?.latitude ?? 17.452938
            let longitude = orderData?.address?.longitude ?? 78.380981
            self.destinations = [
                CLLocationCoordinate2D(latitude: latitude, longitude: longitude), // Destination 1
            ]
        }
       // let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10)
        let camera = GMSCameraPosition.camera(withLatitude: storeLatitude, longitude:storeLongitude, zoom: 10)
        mapView = GMSMapView(frame: self.mapContainerView.frame, camera: camera)
        self.mapContainerView.addSubview(mapView)
        // Ensure the map resizes properly
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: mapContainerView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor)
        ])
        
        // Setup location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Show markers for all destinations
        showDestinationMarkers()
        // Add zoom buttons
           addZoomControls()
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NextBtnAct(_ sender: UIButton) {
        let vc = MAIN.instantiateViewController(withIdentifier: "ConfirmDeliveryVC") as! ConfirmDeliveryVC
        vc.orderData = self.orderData
        navigationController?.pushViewController(vc, animated: true)
    }

    func showDestinationMarkers() {
        for destination in destinations {
            let marker = GMSMarker(position: destination)
            marker.map = mapView
        }
    }
    // Get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = CLLocation(latitude: storeLatitude, longitude:storeLongitude)
        let ll = currentLocation ?? CLLocation(latitude: 40.730610, longitude: -73.935242)
        locationManager.stopUpdatingLocation() // Stop updating to save battery
        // Show a marker for the user's current location
//           let marker = GMSMarker(position: location.coordinate)
//           marker.title = "Current Location"
//        marker.icon = UIImage(named: "current_location_icon") // Replace with your custom icon
//           marker.map = mapView
        // Show a circle for the user's current location (as a dot)
        let circle = GMSCircle(position: ll.coordinate, radius: 50) // 20 is the radius in meters
        circle.fillColor = UIColor.red // Blue with some transparency
        circle.strokeColor = UIColor.blue // Stroke color for border
            circle.strokeWidth = 4.0 // Border thickness
            circle.map = mapView
        // Show all markers, including the user's current location
           showDestinationMarkers()
           updateMapCamera()
        // Find the nearest destination and show route
        calculateAndShowRoutes()
    }
    func updateMapCamera() {
        guard let currentLocation = currentLocation else { return }

        var bounds = GMSCoordinateBounds()

        // Include current location
        bounds = bounds.includingCoordinate(currentLocation.coordinate)

        // Include all destination markers
        for destination in destinations {
            bounds = bounds.includingCoordinate(destination)
        }

        // Animate camera to fit all markers
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50) // Add padding for better visibility
        mapView.animate(with: update)
    }
    func calculateAndShowRoutes() {
        guard let currentLocation = currentLocation else { return }
        
        // Sort destinations by distance from current location
        let sortedDestinations = destinations.sorted {
            currentLocation.distance(from: CLLocation(latitude: $0.latitude, longitude: $0.longitude)) <
                currentLocation.distance(from: CLLocation(latitude: $1.latitude, longitude: $1.longitude))
        }
        // Show route: Current Location → Nearest → Second Nearest → Third
        if let first = sortedDestinations.first {
            getRoute(from: currentLocation.coordinate, to: first) {
                if let second = sortedDestinations.dropFirst().first {
                    self.getRoute(from: first, to: second) {
                        if let third = sortedDestinations.dropFirst(2).first {
                            self.getRoute(from: second, to: third, completion: nil)
                        }
                    }
                }
            }
        }
    }
    func getRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completion: (() -> Void)?) {
        let apiKey = "AIzaSyD09AGUnxXVmRLRFZ0R4AWVE_qPgyoecjg"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(end.latitude),\(end.longitude)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let routes = json?["routes"] as? [[String: Any]], let route = routes.first,
                   let overviewPolyline = route["overview_polyline"] as? [String: Any],
                   let points = overviewPolyline["points"] as? String {
                    
                    DispatchQueue.main.async {
                        self.drawRoute(with: points)
                        completion?()
                    }
                }
            } catch {
                print("Error parsing JSON:", error)
            }
        }.resume()
    }
    func drawRoute(with encodedPath: String) {
        let path = GMSPath(fromEncodedPath: encodedPath)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.strokeColor = .blue
        polyline.map = mapView
    }
}

extension GoogleMapViewController {
    func addZoomControls() {
        // Zoom In (+) Button
        let zoomInButton = UIButton(type: .system)
        zoomInButton.frame = CGRect(x: self.view.frame.width - 65, y: self.view.frame.height - 230, width: 40, height: 40)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        zoomInButton.backgroundColor = UIColor.white
        zoomInButton.layer.cornerRadius = 20
        zoomInButton.layer.shadowColor = UIColor.black.cgColor
        zoomInButton.layer.shadowOpacity = 0.3
        zoomInButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        self.view.addSubview(zoomInButton)

        // Zoom Out (-) Button
        let zoomOutButton = UIButton(type: .system)
        zoomOutButton.frame = CGRect(x: self.view.frame.width - 65, y: self.view.frame.height - 180, width: 40, height: 40)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        zoomOutButton.backgroundColor = UIColor.white
        zoomOutButton.layer.cornerRadius = 20
        zoomOutButton.layer.shadowColor = UIColor.black.cgColor
        zoomOutButton.layer.shadowOpacity = 0.3
        zoomOutButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        self.view.addSubview(zoomOutButton)
    }
    @objc func zoomIn() {
        let zoomLevel = mapView.camera.zoom + 1
        let cameraUpdate = GMSCameraUpdate.zoom(to: zoomLevel)
        mapView.animate(with: cameraUpdate)
    }

    @objc func zoomOut() {
        let zoomLevel = mapView.camera.zoom - 1
        let cameraUpdate = GMSCameraUpdate.zoom(to: zoomLevel)
        mapView.animate(with: cameraUpdate)
    }
}
