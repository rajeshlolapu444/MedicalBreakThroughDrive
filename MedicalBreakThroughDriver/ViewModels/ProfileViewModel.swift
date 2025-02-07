//
//  ProfileViewModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 07/02/25.
//

import Foundation
import UIKit

class ProfileViewModel {
    
    static let shared = ProfileViewModel()
    
    func getDriverProfileAPI(completion: @escaping (_ status:Bool, _ msg:String?) -> Void) {
        let url = GET_DRIVER_DETAILS_URL
        debugPrint(url,"GET_DRIVER_DETAILS_URL")
        APIModel.getRequest(strURL:url, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(DriverProfileResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                PersistenceStorage.sharedInstance.driverProfileData = response?.data
                completion(true,"")
            } else {
                completion(false,response?.message ?? "")
            }
        } failure: { error in
            completion(false,error)
        }
    }
}

// MARK: - Driver Profile ResponseModel
struct DriverProfileResponseModel: Codable {
    let message: String?
       let status: Int?
       let data: DriverProfileModel?
   }

   // MARK: - Driver Profile Model
   struct DriverProfileModel: Codable {
       let id: Int?
       let firstName, lastName, name, email: String?
       let phone,profileImage: String?
       let department: Department?

       enum CodingKeys: String, CodingKey {
           case id
           case firstName = "first_name"
           case lastName = "last_name"
           case name, email, phone, department
           case profileImage = "profile_image"
       }
   }

   // MARK: - Department
   struct Department: Codable {
       let id: Int?
       let name, aliasName: String?

       enum CodingKeys: String, CodingKey {
           case id, name
           case aliasName = "alias_name"
       }
   }
