//
//  MapGoogleViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 18/02/25.
//

import UIKit
import MapKit
import CoreLocation

//17.43772636828794,78.39512477322054
//17.48581167804096, 78.35855975339823
class MapGoogleViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var zoomBgView: UIView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    
    var isFromHome : Bool = false
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    // Set your destination coordinates
    //let destinationCoordinate = CLLocationCoordinate2D(latitude: 17.48581167804096, longitude: 78.39512477322054)
    var destinations: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 17.48581167804096, longitude: 78.39512477322054)//,
            //CLLocationCoordinate2D(latitude: 17.48581167804096, longitude: 78.35855975339823) // Sacramento
        ]
    var orderData : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
       // addDestinationMarker()
        zoomInButton.addTarget(self, action: #selector(zoomInAction), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOutAction), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
        nextBtn.setTitle("Start", for: .normal)
        nextBtn.isHidden = isFromHome
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func setupMapView() {
        mapView.frame = view.bounds
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapContainerView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: mapContainerView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor)
        ])
    }
    @objc func nextBtnAct() {
        if nextBtn.titleLabel?.text == "Next" {
            let vc = MAIN.instantiateViewController(withIdentifier: "ConfirmDeliveryVC") as! ConfirmDeliveryVC
            vc.orderData = orderData
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let lat = orderData?.address?.latitude ?? 0
            let long = orderData?.address?.longitude ?? 0
            if lat != 0 && long != 0 && orderData?.address?.latitude != nil && orderData?.address?.longitude != nil {
                self.openGoogleMaps(destinationLat: orderData?.address?.latitude ?? 0, destinationLng: orderData?.address?.longitude ?? 0 )
            } else {
                self.showToast(message: "No Location Found")
            }
        }
    }
    func openGoogleMaps(destinationLat: Double, destinationLng: Double) {
        nextBtn.setTitle("Next", for: .normal)
        let urlString = "comgooglemaps://?saddr=&daddr=\(destinationLat),\(destinationLng)&directionsmode=driving"

        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // If Google Maps is not installed, open in Safari using Google Maps web
                let webURLString = "https://www.google.com/maps/dir/?api=1&destination=\(destinationLat),\(destinationLng)"
                if let webURL = URL(string: webURLString) {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        
        let userCoordinate = userLocation.coordinate
        // Set initial zoom level
        let region = MKCoordinateRegion(
            center: userCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Adjust zoom level
        )
        mapView.setRegion(region, animated: true)
        planRoute(from: userCoordinate, to: destinations)
    }
    
    func planRoute(from startLocation: CLLocationCoordinate2D, to destinations: [CLLocationCoordinate2D]) {
        var sortedDestinations = destinations.sorted { (loc1, loc2) -> Bool in
            let dist1 = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude).distance(from: CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude))
            let dist2 = CLLocation(latitude: loc2.latitude, longitude: loc2.longitude).distance(from: CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude))
            return dist1 < dist2
        }
        
        sortedDestinations.insert(startLocation, at: 0) // Start from current location
        drawRoute(for: sortedDestinations)
    }
    
    func drawRoute(for locations: [CLLocationCoordinate2D]) {
        guard locations.count > 1 else { return }
        
        for i in 0..<locations.count - 1 {
            let sourcePlacemark = MKPlacemark(coordinate: locations[i])
            let destinationPlacemark = MKPlacemark(coordinate: locations[i + 1])
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let request = MKDirections.Request()
            request.source = sourceMapItem
            request.destination = destinationMapItem
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let response = response, let route = response.routes.first else { return }
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(self.mapView.visibleMapRect.union(route.polyline.boundingMapRect), animated: true)
            }
        }
        
        addDestinationMarkers(for: Array(locations.dropFirst())) // Add markers for destinations
    }
    
    func addDestinationMarkers(for locations: [CLLocationCoordinate2D]) {
        for (index, location) in locations.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Destination \(index + 1)"
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    //    func addDestinationMarker() {
    //        let annotation = MKPointAnnotation()
    //        annotation.coordinate = destinationCoordinate
    //        annotation.title = "Destination"
    //        annotation.subtitle = "Your target location"
    //        mapView.addAnnotation(annotation)
    //    }
    
    @objc func zoomInAction() {
        var region = mapView.region
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
        mapView.setRegion(region, animated: true)
    }
    
    @objc func zoomOutAction() {
        var region = mapView.region
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        mapView.setRegion(region, animated: true)
    }
}
