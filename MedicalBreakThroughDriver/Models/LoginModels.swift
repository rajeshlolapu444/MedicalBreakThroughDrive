//
//  LoginModels.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 13/02/25.
//

import Foundation

// MARK: - LoginRequestModel
struct LoginRequestModel: Encodable {
    let email, password: String?
}
// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let message : String?
    let status : Int?
    let data : LoginResponseDataModel?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case status = "status"
        case data = "data"
    }
}
struct LoginResponseDataModel: Codable {
    let accessToken : String?
   
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

// MARK: - ForgotPasswordRequestModel
struct ForgotPasswordRequestModel: Encodable {
    let email: String?
}
// MARK: - ForgotPasswordResponseModel
struct ForgotPasswordResponseModel: Codable {
    let message : String?
    let status : Int?
    let success : Bool?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case status = "status"
        case success = "success"
    }
}
// MARK: - verifyOtpRequestModel
struct VerifyOtpRequestModel: Encodable {
    let email: String?
    let otp: String?
}
// MARK: - VerifyOtpResponseModel
struct VerifyOtpResponseModel: Codable {
    let message : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
}
// MARK: - NewPasswordRequestModel
struct NewPasswordRequestModel: Encodable {
    let email: String?
    let password: String?
    let password_confirmation: String?
}
// MARK: - NewPasswordResponseModel
struct NewPasswordResponseModel: Codable {
    let message : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
}


