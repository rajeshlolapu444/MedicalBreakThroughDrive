//
//  PersistenceStorage.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 04/02/25.
//

import Foundation
import UIKit

class PersistenceStorage {
    
    static let sharedInstance = PersistenceStorage()
    let defaults = UserDefaults.standard
    
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
}
