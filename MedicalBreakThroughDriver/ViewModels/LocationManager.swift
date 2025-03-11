//
//  LocationManager.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 19/02/25.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var onLocationAuthorized: ((_ latitude: Double, _ longitude: Double) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Request permission
    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            showLocationAlert()
        }
    }
    
    // Handle permission changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start fetching location
        case .denied, .restricted:
            showLocationAlert()
        default:
            break
        }
    }
    
    // Fetch current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation() // Stop updates to save battery
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Current Location: \(latitude), \(longitude)")
        PersistenceStorage.sharedInstance.currentLocationCoordinates = location.coordinate
        onLocationAuthorized?(latitude, longitude) // Pass coordinates to handler
    }
    
    // Alert if permission is denied
    private func showLocationAlert() {
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                let alert = UIAlertController(
                    title: "Location Required",
                    message: "Please enable location access to use this app.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                })
                topVC.present(alert, animated: true)
            }
        }
    }
}
