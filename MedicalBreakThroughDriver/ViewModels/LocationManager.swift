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
    var currentLocation: CLLocationCoordinate2D?
    var completion: ((CLLocationCoordinate2D?) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Request location on app launch
    func requestLocationOnLaunch() {
        let status = locationManager.authorizationStatus // ✅ Use instance property instead of deprecated method
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Request permission
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start location updates
        case .denied, .restricted:
            UserDefaults.standard.set(true, forKey: "RequestLocationOnHomePage")
        @unknown default:
            break
        }
    }
    
    /// Request location again on the home page if needed
    func requestLocationOnHomePage(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        self.completion = completion
        let status = locationManager.authorizationStatus // ✅ Updated
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            showLocationDeniedAlert()
            completion(nil)
        }
    }
    
    /// ✅ Corrected this function to ensure location is properly retrieved
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        PersistenceStorage.sharedInstance.currentLocationCoordinates = currentLocation
        locationManager.stopUpdatingLocation()
        completion?(location.coordinate)
    }
    
    /// Handle failure cases
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        completion?(nil)
    }
    
    /// Show an alert if location is denied
    private func showLocationDeniedAlert() {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.shared.windows.first?.rootViewController else { return }
            
            let alert = UIAlertController(
                title: "Location Required",
                message: "To continue, please enable location in Settings.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            topVC.present(alert, animated: true)
        }
    }
}
