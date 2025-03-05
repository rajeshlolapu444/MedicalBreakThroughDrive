//
//  SignupModels.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/03/25.
//

import Foundation

// MARK: - SignupEmailRequestModel
struct SignupEmailRequestModel: Encodable {
    let email : String?
}

// MARK: - SignupEmailResponseModel
struct  SignupEmailResponseModel: Codable {
    let message : String?
    let status : Int?
    let success : Bool?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case status = "status"
        case success = "success"
    }
}

// MARK: - SignupVerifyOtpRequestModel
struct SignupVerifyOtpRequestModel: Encodable {
    let first_name: String?
    let last_name: String?
    let email: String?
    let mobile_number: Int?
    let password: String?
    let otp: Int?
}
