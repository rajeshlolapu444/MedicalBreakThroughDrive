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
    @IBOutlet weak var titleLbl: UILabel!
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
    var ordersArray: [Order] = []
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
        self.titleLbl.text = isFromHome ? "Route" : "Delivery Direction"
        
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackAct(_ sender: UIButton) {
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
                //self.openGoogleMaps(destinationLat: orderData?.address?.latitude ?? 0, destinationLng: orderData?.address?.longitude ?? 0 )
                self.openAppleMaps(destinationLat: orderData?.address?.latitude ?? 0, destinationLng: orderData?.address?.longitude ?? 0 )
            } else {
                self.showToast(message: "No Location Found")
            }
        }
    }
    // MARK: - GoogleMaps
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
    // MARK: - AppleMaps
    func openAppleMaps(destinationLat: Double, destinationLng: Double) {
        let destinationCoordinates = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        //17.48581167804096, longitude: 78.39512477322054
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        mapItem.name = "Destination"
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    // Function to add a marker at a specific location
    func addMarker(at coordinate: CLLocationCoordinate2D, title: String, subtitle: String? = nil) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let storeLatitude = PersistenceStorage.sharedInstance.storeAddressLatitude ?? 0
        let storeLongititude = PersistenceStorage.sharedInstance.storeAddressLongitude ?? 0
        let customCurrentLocation = CLLocationCoordinate2D(latitude: storeLatitude, longitude: storeLongititude)
        let userCoordinate = customCurrentLocation
        addMarker(at: userCoordinate, title:"", subtitle: "")
        //let userCoordinate = userLocation.coordinate
        // Set initial zoom level
        let region = MKCoordinateRegion(
            center: userCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Adjust zoom level
        )
        mapView.setRegion(region, animated: true)
        planRoute(from: userCoordinate, to: destinations)
    }
    
//    func planRoute(from startLocation: CLLocationCoordinate2D, to destinations: [CLLocationCoordinate2D]) {
//        var sortedDestinations = destinations.sorted { (loc1, loc2) -> Bool in
//            let dist1 = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude).distance(from: CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude))
//            let dist2 = CLLocation(latitude: loc2.latitude, longitude: loc2.longitude).distance(from: CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude))
//            return dist1 < dist2
//        }
//        
//        sortedDestinations.insert(startLocation, at: 0) // Start from current location
//        drawRoute(for: sortedDestinations)
//    }
    func planRoute(from startLocation: CLLocationCoordinate2D, to destinations: [CLLocationCoordinate2D]) {
        let routeLocations = [startLocation] + destinations // Maintain given order
        drawRoute(for: routeLocations)
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
            //let annotation = CustomAnnotation(coordinate: location, title: "Destination \(index + 1)")
            if isFromHome {
                let data = "\(ordersArray[index].customer?.name ?? ""),\n\(ordersArray[index].address?.addressLine1 ?? ""), \(ordersArray[index].address?.city ?? ""),\(ordersArray[index].address?.state ?? ""), \(ordersArray[index].address?.country ?? ""),\(ordersArray[index].address?.postalCode ?? "")"
                let annotation = CustomAnnotation(coordinate: location, title:data)
                mapView.addAnnotation(annotation)
            } else {
                let data = "\(orderData?.customer?.name ?? ""),\n\(orderData?.address?.addressLine1 ?? ""), \(orderData?.address?.city ?? ""),\(orderData?.address?.state ?? ""), \(orderData?.address?.country ?? ""),\(orderData?.address?.postalCode ?? "")"
                let annotation = CustomAnnotation(coordinate: location, title:data)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    //    func addDestinationMarkers(for locations: [CLLocationCoordinate2D]) {
    //        for (index, location) in locations.enumerated() {
    //            let annotation = MKPointAnnotation()
    //            annotation.coordinate = location
    //            annotation.title = "Destination \(index + 1)"
    //            if isFromHome {
    //                let data = "\(ordersArray[index].customer?.name ?? ""),\n\(ordersArray[index].address?.addressLine1 ?? ""), \(ordersArray[index].address?.city ?? ""),\(ordersArray[index].address?.state ?? ""), \(ordersArray[index].address?.country ?? ""),\(ordersArray[index].address?.postalCode ?? "")"
    //                annotation.title = data
    //            } else {
    //                let data = "\(orderData?.customer?.name ?? ""),\n\(orderData?.address?.addressLine1 ?? ""), \(orderData?.address?.city ?? ""),\(orderData?.address?.state ?? ""), \(orderData?.address?.country ?? ""),\(orderData?.address?.postalCode ?? "")"
    //                annotation.title = data
    //            }
    //
    //            mapView.addAnnotation(annotation)
    //        }
    //    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
        
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        
        let identifier = "customMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true // Enables pop-up title
            
            // Set marker color and icon
            annotationView?.markerTintColor = .red // Marker color
            annotationView?.glyphText = "📍" // Custom marker glyph (emoji or single character)
            
            // Create the label
            let label = UILabel()
            label.text = customAnnotation.title
            label.textColor = .black // Text color
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 12)
            label.backgroundColor = .white // Background for visibility
            label.layer.cornerRadius = 5
            label.layer.borderColor = UIColor.gray.cgColor // Border color
            label.layer.borderWidth = 2 // Border width
            label.clipsToBounds = true
            label.numberOfLines = 0 // Allow multiple lines
            
            // Dynamic size
            let maxWidth: CGFloat = 150
            let maxHeight: CGFloat = 100 // Maximum height (adjust if needed)
            let size = label.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            label.frame = CGRect(x: -50, y: 30, width: maxWidth, height: min(size.height, maxHeight))
            
            annotationView?.addSubview(label)
        } else {
            annotationView?.annotation = customAnnotation
        }
        
        return annotationView
    }
}
// Custom annotation class
class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
