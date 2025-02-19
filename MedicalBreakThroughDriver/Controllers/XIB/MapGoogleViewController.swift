//
//  MapGoogleViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 18/02/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
//17.43772636828794,78.39512477322054
//17.48581167804096, 78.35855975339823
class MapGoogleViewController: UIViewController {
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var zoomBgView: UIView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    var isTracking = false
    var destinationCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 17.48581167804096, longitude: 78.35855975339823) // Example destination
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocationMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    var routePolyline: GMSPolyline?
    
    var orderData : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomBgView.layer.borderWidth = 1
        zoomBgView.layer.borderColor = UIColor.darkGray.cgColor
           // Initialize map
           let camera = GMSCameraPosition.camera(withLatitude: 17.48581167804096, longitude: 78.35855975339823, zoom: 10)
        let lat = orderData?.address?.latitude ?? 0
        let longi = orderData?.address?.longitude ?? 0
       // destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: longi)
//        let camera = GMSCameraPosition.camera(
//                withLatitude: 17.43772636828794,
//                longitude: 78.39512477322054,
//                zoom: 10,
//                bearing: 45,
//                viewingAngle: 45
//            )
           mapView = GMSMapView(frame: self.mapContainerView.frame, camera: camera)
        mapView.mapType = .normal
        //mapView.isBuildingsEnabled = true
        mapView.isMyLocationEnabled = true
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
        nextBtn.setTitle("Start Tracking", for: .normal)
        nextBtn.isHidden = false
        nextBtn.addTarget(self, action: #selector(startTracking), for: .touchUpInside)
        addZoomControls()
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func startTracking() {
        if self.nextBtn.titleLabel?.text == "Start Tracking" {
            isTracking = true
            locationManager.startUpdatingLocation()
            nextBtn.isHidden = true
            if let destination = destinationCoordinate {
                destinationMarker = GMSMarker(position: destination)
                destinationMarker?.title = "Destination"
                destinationMarker?.icon = GMSMarker.markerImage(with: .red)
                destinationMarker?.map = mapView
            }
        } else {
            self.onDestinationReached()
        }

    }
//    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        let apiKey = "AIzaSyD09AGUnxXVmRLRFZ0R4AWVE_qPgyoecjg"
//        
//        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=\(apiKey)"
//        
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching directions: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                if let routes = json?["routes"] as? [[String: Any]], let firstRoute = routes.first,
//                   let overviewPolyline = firstRoute["overview_polyline"] as? [String: Any],
//                   let polylinePoints = overviewPolyline["points"] as? String {
//                    
//                    DispatchQueue.main.async {
//                        self.drawRoute(with: polylinePoints)
//                    }
//                }
//            } catch {
//                print("Failed to parse JSON: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
    func adjustMapZoomToFitMarkers(currentLocation: CLLocationCoordinate2D, destinations: CLLocationCoordinate2D) {
        var bounds = GMSCoordinateBounds(coordinate: currentLocation, coordinate: currentLocation)

        bounds = bounds.includingCoordinate(destinations)

        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: update)
    }
}

extension MapGoogleViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if isTracking {
            // Update current location marker
            if currentLocationMarker == nil {
                currentLocationMarker = GMSMarker()
                currentLocationMarker?.icon = GMSMarker.markerImage(with: .blue)
                //currentLocationMarker?.icon = UIImage(named: "navigation") // Replace with your custom icon
                currentLocationMarker?.map = mapView
            }
            currentLocationMarker?.position = location.coordinate
            
            // Update camera to follow the user
            let cameraUpdate = GMSCameraUpdate.setTarget(location.coordinate)
            mapView.animate(with: cameraUpdate)
            
            // Fetch new route from current location
            if let destination = destinationCoordinate {
               // fetchRoute(from: location.coordinate, to: destination)
                
                // Check if the user has arrived
                if hasReachedDestination(userLocation: location.coordinate, destination: destination) {
                    trackingCompleted()
                }
            }
        } else {
            // Stop location updates temporarily (until tracking starts)
            locationManager.stopUpdatingLocation()
            
            let userLocation = location.coordinate
            if let destination = destinationCoordinate {
              //  fetchRoute(from: userLocation, to: destination) // Fetch the route before tracking starts
                // Adjust zoom to fit all markers
                    adjustMapZoomToFitMarkers(currentLocation: userLocation, destinations: destination)
            }
            
        }

    }
    func drawRoute(with encodedPath: String) {
        let path = GMSPath(fromEncodedPath: encodedPath)
        routePolyline?.map = nil // Remove old route
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 3
        polyline.map = mapView
        
        routePolyline = polyline
    }
    func hasReachedDestination(userLocation: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Bool {
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destLoc = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        let distance = userLoc.distance(from: destLoc) // Distance in meters
        
        return distance < 10 // Stop tracking when within 20 meters
    }

    func trackingCompleted() {
        isTracking = false
        locationManager.stopUpdatingLocation()
        
//        let alert = UIAlertController(title: "Arrived!", message: "You have reached your destination.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        self.nextBtn.isHidden = false
        self.nextBtn.setTitle("Next", for: .normal)
    }

    func onDestinationReached() {
        print("Destination reached! Perform any additional actions here.")
        let vc = MAIN.instantiateViewController(withIdentifier: "ConfirmDeliveryVC") as! ConfirmDeliveryVC
        vc.orderData = self.orderData
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MapGoogleViewController {
    func addZoomControls() {
        // Zoom In (+) Button
//        let zoomInButton = UIButton(type: .system)
//        zoomInButton.frame = CGRect(x: self.view.frame.width - 65, y: self.view.frame.height - 230, width: 40, height: 40)
//        zoomInButton.setTitle("+", for: .normal)
//        zoomInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
//        zoomInButton.backgroundColor = UIColor.white
//        zoomInButton.layer.cornerRadius = 20
//        zoomInButton.layer.shadowColor = UIColor.black.cgColor
//        zoomInButton.layer.shadowOpacity = 0.3
//        zoomInButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        //self.view.addSubview(zoomInButton)

        // Zoom Out (-) Button
//        let zoomOutButton = UIButton(type: .system)
//        zoomOutButton.frame = CGRect(x: self.view.frame.width - 65, y: self.view.frame.height - 180, width: 40, height: 40)
//        zoomOutButton.setTitle("-", for: .normal)
//        zoomOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
//        zoomOutButton.backgroundColor = UIColor.white
//        zoomOutButton.layer.cornerRadius = 20
//        zoomOutButton.layer.shadowColor = UIColor.black.cgColor
//        zoomOutButton.layer.shadowOpacity = 0.3
//        zoomOutButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
      //  self.view.addSubview(zoomOutButton)
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
