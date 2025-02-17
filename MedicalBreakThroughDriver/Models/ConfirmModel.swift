//
//  ConfirmModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 12/02/25.
//

import Foundation

// MARK: - Confirm Delivery Reuest Model
// MARK: - deliverd/finished
struct ConfirmDeliveryRequestModel: Encodable {
    let order_id: Int?
    let status: String?
    let attachments: [AttechmentRequestModel]?
    let reason: String?
}
struct AttechmentRequestModel: Encodable {
    var attachment_type: String?
    var url: String?
}

// MARK: - rejected/cancelled
struct CancelledDeliveryRequestModel: Encodable {
    let order_id: Int?
    let status: String?
    let reason: String?
}

//
//var isTracking = false // Track if user started the navigation
//var destinationCoordinate: CLLocationCoordinate2D?
//
//@objc func startTracking() {
//    isTracking = true
//    locationManager.startUpdatingLocation() // Start continuous location updates
//}
//
//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    guard let location = locations.last else { return }
//
//    if isTracking {
//        // Update current location on the map
//        let userPosition = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
//        mapView.animate(to: userPosition)
//
//        // Update user's marker (dot)
//        mapView.clear() // Clear previous markers
//        let userMarker = GMSMarker(position: location.coordinate)
//        userMarker.icon = UIImage(named: "current_location_icon") // Use a dot image
//        userMarker.map = mapView
//        
//        // Re-draw the route from the current location to the destination
//        if let destination = destinationCoordinate {
//            drawRoute(from: location.coordinate, to: destination)
//            
//            // Check if user has reached the destination
//            if hasReachedDestination(userLocation: location.coordinate, destination: destination) {
//                trackingCompleted()
//            }
//        }
//    }
//}
//func hasReachedDestination(userLocation: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Bool {
//    let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
//    let destLoc = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
//    
//    let distance = userLoc.distance(from: destLoc) // Distance in meters
//    
//    return distance < 20 // Consider the user has arrived if they are within 20 meters
//}
//func trackingCompleted() {
//    isTracking = false
//    locationManager.stopUpdatingLocation() // Stop tracking
//
//    let alert = UIAlertController(title: "Arrived!", message: "You have reached your destination.", preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//    self.present(alert, animated: true, completion: nil)
//
//    // Call any other function you want
//    onDestinationReached()
//}
//
//func onDestinationReached() {
//    print("Destination reached! Perform any additional actions here.")
//}
//func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//    let path = GMSMutablePath()
//    path.add(source)
//    path.add(destination)
//    
//    let polyline = GMSPolyline(path: path)
//    polyline.strokeColor = .blue
//    polyline.strokeWidth = 5
//    polyline.map = mapView
//}
