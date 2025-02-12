//
//  MapViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 31/01/25.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var mapContainerView: UIView!
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
  //  let destinationCoordinate = CLLocationCoordinate2D(latitude: 17.452938, longitude: 78.380981) // Your destination coordinates
    var userCoordinate: CLLocationCoordinate2D?
    var destinations: [CLLocationCoordinate2D] = [
           CLLocationCoordinate2D(latitude: 17.452938, longitude: 78.380981), // Destination 1
           CLLocationCoordinate2D(latitude: 17.496602, longitude: 78.367925), // Destination 2
           CLLocationCoordinate2D(latitude: 17.476824, longitude: 78.421963)  // Destination 3
       ]

       var sortedDestinations: [CLLocationCoordinate2D] = []
    
    var userLocationAnnotation: MKPointAnnotation?
    var previousUserCoordinate: CLLocationCoordinate2D?
    var orderData : Order?
    var isfromSummary : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextBtn.isHidden = isfromSummary
        mapKitView.delegate = self
        mapKitView.showsUserLocation = true
        setupLocationManager()
        addAllDestinationMarkers()
        // Add marker for destination
                //addMarker(at: destinationCoordinate, title: "Destination")
//        // Request location permission
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
//        // Initialize Google Map with a default camera position
//                let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 15.0)
//                mapView = GMSMapView(frame: .zero, camera: camera)
//                mapView.isMyLocationEnabled = true
//        
//        // Add mapView as a subview of mapContainerView
//        mapContainerView.addSubview(mapView)
//        
//        // Ensure the map resizes properly
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            mapView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor),
//            mapView.topAnchor.constraint(equalTo: mapContainerView.topAnchor),
//            mapView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor)
//        ])
        
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        
//        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        mapView.animate(to: GMSCameraPosition.camera(withTarget: position, zoom: 2.0))
//        
//        // Add marker
//        let marker = GMSMarker(position: position)
//        marker.title = "You are here"
//        marker.map = mapView
//        
//        locationManager.stopUpdatingLocation()
//    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NextBtnAct(_ sender: UIButton) {
//        let vc = ProofOfDeliveryVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = MAIN.instantiateViewController(withIdentifier: "ConfirmDeliveryVC") as! ConfirmDeliveryVC
        vc.orderData = self.orderData
        navigationController?.pushViewController(vc, animated: true)
    }
}
//extension MapViewController {
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////            guard let location = locations.last else { return }
////
////            let coordinate = location.coordinate
////            let region = MKCoordinateRegion(
////                center: coordinate,
////                latitudinalMeters: 500,
////                longitudinalMeters: 500
////            )
////            
////            mapKitView.setRegion(region, animated: true)
////
////            // Add a marker (Annotation)
////            let annotation = MKPointAnnotation()
////            annotation.coordinate = coordinate
////            annotation.title = "You are here"
////            mapKitView.addAnnotation(annotation)
//            guard let userLocation = locations.last else { return }
//            let userCoordinate = userLocation.coordinate
//            // Add marker for user location
//                   addMarker(at: userCoordinate, title: "You are here")
//
//                   // Add marker for destination
//                   addMarker(at: destinationCoordinate, title: "Destination")
//            drawRoute(from: userCoordinate, to: destinationCoordinate)
//            
//            locationManager.stopUpdatingLocation()
//        }
//    func addMarker(at coordinate: CLLocationCoordinate2D, title: String) {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = title
//        mapKitView.addAnnotation(annotation)
//        }
//    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//            let sourcePlacemark = MKPlacemark(coordinate: source)
//            let destinationPlacemark = MKPlacemark(coordinate: destination)
//
//            let sourceItem = MKMapItem(placemark: sourcePlacemark)
//            let destinationItem = MKMapItem(placemark: destinationPlacemark)
//
//            let directionRequest = MKDirections.Request()
//            directionRequest.source = sourceItem
//            directionRequest.destination = destinationItem
//            directionRequest.transportType = .automobile // Change to .walking if needed
//
//            let directions = MKDirections(request: directionRequest)
//            directions.calculate { (response, error) in
//                guard let response = response, let route = response.routes.first else { return }
//
//                self.mapKitView.addOverlay(route.polyline, level: .aboveRoads)
//
//                let region = MKCoordinateRegion(
//                    center: source,
//                    latitudinalMeters: 5000,
//                    longitudinalMeters: 5000
//                )
//                self.mapKitView.setRegion(region, animated: true)
//            }
//        }
//    }
// MARK: - MKMapViewDelegate for Drawing Route
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    // Custom annotation view with an image for the user location
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           if annotation is MKUserLocation {
               return nil // Keep default user location
           }

           let identifier = "CustomMarker"
           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

           if annotation === userLocationAnnotation {
               annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               annotationView?.image = UIImage(named: "radio-buttons") // Use your custom image
               annotationView?.canShowCallout = false
           } else {
               annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               annotationView?.canShowCallout = true
           }

           return annotationView
       }
}

//extension MapViewController {
//    func setupLocationManager() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
//        }
//
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let userLocation = locations.last else { return }
//            let userCoordinate = userLocation.coordinate
//
//            // Update current location marker dynamically
//            updateUserMarker(at: userCoordinate)
//
//            // Only update route if the user has moved significantly (10 meters)
//            if previousUserCoordinate == nil || distanceBetween(previousUserCoordinate!, userCoordinate) > 10 {
//                previousUserCoordinate = userCoordinate
//                updateRoute(from: userCoordinate, to: destinationCoordinate)
//            }
//
//            // Keep the camera centered on the user
//            let region = MKCoordinateRegion(
//                center: userCoordinate,
//                latitudinalMeters: 1000,
//                longitudinalMeters: 1000
//            )
//            mapKitView.setRegion(region, animated: true)
//        }
//
//        func updateUserMarker(at coordinate: CLLocationCoordinate2D) {
//            // Remove previous user location marker
//            if let existingAnnotation = userLocationAnnotation {
//                mapKitView.removeAnnotation(existingAnnotation)
//            }
//
//            // Add a new user location marker
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "You are here"
//            mapKitView.addAnnotation(annotation)
//
//            // Store reference for future updates
//            userLocationAnnotation = annotation
//        }
//
//        func addMarker(at coordinate: CLLocationCoordinate2D, title: String) {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = title
//            mapKitView.addAnnotation(annotation)
//        }
//
//        func updateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//            // Remove old routes
//            mapKitView.overlays.forEach { if $0 is MKPolyline { mapKitView.removeOverlay($0) } }
//
//            let sourcePlacemark = MKPlacemark(coordinate: source)
//            let destinationPlacemark = MKPlacemark(coordinate: destination)
//
//            let directionRequest = MKDirections.Request()
//            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
//            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
//            directionRequest.transportType = .automobile
//
//            let directions = MKDirections(request: directionRequest)
//            directions.calculate { (response, error) in
//                guard let response = response, let route = response.routes.first else { return }
//                self.mapKitView.addOverlay(route.polyline, level: .aboveRoads)
//            }
//        }
//
//        func distanceBetween(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> CLLocationDistance {
//            let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
//            let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
//            return loc1.distance(from: loc2)
//        }
//    }

extension MapViewController {
   
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        userCoordinate = userLocation.coordinate

        // Sort destinations based on distance from user
        sortedDestinations = destinations.sorted { (loc1, loc2) in
            let distance1 = distanceBetween(userLocation.coordinate, loc1)
            let distance2 = distanceBetween(userLocation.coordinate, loc2)
            return distance1 < distance2
        }

        // Add all destination markers
        addAllDestinationMarkers()

        // Show all routes at the same time in order
        drawRoutes()
    }

    func drawRoutes() {
        guard let userLocation = userCoordinate else { return }
        
        let allLocations = [userLocation] + sortedDestinations // Start with user location

        for i in 0..<allLocations.count - 1 {
            let source = allLocations[i]
            let destination = allLocations[i + 1]
            drawRoute(from: source, to: destination)
        }
        adjustMapZoom()
    }
    func adjustMapZoom() {
        var zoomRect = MKMapRect.null

        // Include user location in zoom calculation
        if let userLocation = userCoordinate {
            let point = MKMapPoint(userLocation)
            zoomRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
        }

        // Include all destinations in zoom calculation
        for destination in sortedDestinations {
            let point = MKMapPoint(destination)
            let rect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            zoomRect = zoomRect.union(rect)
        }

        // Apply a padding so markers don't touch screen edges
        let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        mapKitView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
    }

    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response, let route = response.routes.first else { return }
            self.mapKitView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }

    func distanceBetween(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return loc1.distance(from: loc2)
    }

    func addAllDestinationMarkers() {
        for (index, coordinate) in sortedDestinations.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Destination \(index + 1)"
            mapKitView.addAnnotation(annotation)
        }
    }
}
