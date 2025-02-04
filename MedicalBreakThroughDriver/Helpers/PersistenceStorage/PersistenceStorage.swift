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
    var driverProfileData: LoginResponseDataModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "DriverProfileData") else {
                return nil
            }
            return try? JSONDecoder().decode(LoginResponseDataModel.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "DriverProfileData")
        }
    }
}
