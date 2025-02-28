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


//func decodeInt(from container: KeyedDecodingContainer<some CodingKey>, forKey key: CodingKey) -> Int? {
//    // Try to decode as an Int
//    if let intValue = try? container.decode(Int.self, forKey: key) {
//        return intValue
//    }
//    // Try to decode as a String and convert to Int
//    if let stringValue = try? container.decode(String.self, forKey: key), let intValue = Int(stringValue) {
//        return intValue
//    }
//    // Try to decode as a Double and convert to Int
//    if let doubleValue = try? container.decode(Double.self, forKey: key) {
//        return Int(doubleValue)
//    }
//    return nil
//}
