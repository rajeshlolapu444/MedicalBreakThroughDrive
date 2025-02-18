//
//  ProfileModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 17/02/25.
//

import Foundation


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


// MARK: - Update Profile Request Model
struct UpdateProfileRequestModel: Encodable {
    let first_name: String?
    let last_name: String?
    let phone: String?
    let profile_image: String?
}


// MARK: - Change Password Request Model
struct ChangePasswordRequestModel: Encodable {
    let old_password: String?
    let new_password: String?
    let new_password_confirmation: String?
}

// MARK: - Change Password Respons Model
struct ChangePasswordResponseModel: Codable {
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
}
