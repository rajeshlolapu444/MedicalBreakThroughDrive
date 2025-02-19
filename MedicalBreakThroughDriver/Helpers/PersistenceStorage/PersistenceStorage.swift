//
//  PersistenceStorage.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 04/02/25.
//

import Foundation
import UIKit
import CoreLocation

class PersistenceStorage {
    
    static let sharedInstance = PersistenceStorage()
    let defaults = UserDefaults.standard
    private static let locationKey = "currentLocationCoordinates"
    var loginResponseData: LoginResponseDataModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "loginResponseData") else {
                return nil
            }
            return try? JSONDecoder().decode(LoginResponseDataModel.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "loginResponseData")
        }
    }
    var driverProfileData: DriverProfileModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "driverProfileData") else {
                return nil
            }
            return try? JSONDecoder().decode(DriverProfileModel.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "driverProfileData")
        }
    }
    var storeAddressLatitude: Double? {
        set (newValue){
            defaults.set(newValue, forKey: "storeAddressLatitude")
        }
        get {
            return defaults.object(forKey: "storeAddressLatitude") as? Double
        }
    }
    var storeAddressLongitude: Double? {
        set (newValue){
            defaults.set(newValue, forKey: "storeAddressLongitude")
        }
        get {
            return defaults.object(forKey: "storeAddressLongitude") as? Double
        }
    }
    var currentLocationCoordinates: CLLocationCoordinate2D? {
        get {
            guard let coordinates = defaults.object(forKey: "currentLocationCoordinates") as? [String: Double] else {
                return nil
            }
            if let latitude = coordinates["latitude"], let longitude = coordinates["longitude"] {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            return nil
        }
        set {
            guard let newValue = newValue else { return }
            let coordinates: [String: Double] = ["latitude": newValue.latitude, "longitude": newValue.longitude]
            defaults.set(coordinates, forKey: "currentLocationCoordinates")
        }
    }
}
