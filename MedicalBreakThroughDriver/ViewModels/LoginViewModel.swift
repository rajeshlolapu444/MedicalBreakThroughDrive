//
//  LoginViewModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 13/02/25.
//

import Foundation
import UIKit
import CoreLocation

class LoginViewModel {
    static let shared = LoginViewModel()
    func loginAPICall(params:LoginRequestModel,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        debugPrint(params,"loginParams")
        debugPrint(LOGIN_URL,"LOGIN_URL")
        APIModel.postRequest(strURL: LOGIN_URL as NSString, postParams: params, postHeaders: ["":""]) { result in
            let loginResponse = try? JSONDecoder().decode(LoginResponseModel.self, from: result as! Data)
            if loginResponse?.status == 200{
                UserDefaults.standard.setValue(loginResponse?.data?.accessToken ?? "", forKey: k_token)
                headers.updateValue("Bearer " + (loginResponse?.data?.accessToken ?? ""), forKey: "Authorization")
                PersistenceStorage.sharedInstance.loginResponseData = loginResponse?.data
                completion(true,loginResponse?.message ?? "")
            }
             else {
                 completion(false,loginResponse?.message ?? "")
            }
        } failureHandler: { error in
            debugPrint(error)
            completion(false,error)
        }
    }
    
    func getCoordinates(for address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
            } else if let location = placemarks?.first?.location {
                completion(location.coordinate, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    func getStoreCoordinates() {
        getCoordinates(for: "24971 Avenue Stanford, Santa Clarita, CA 91355") { coordinate, error in
            if let coordinate = coordinate {
                print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                PersistenceStorage.sharedInstance.storeAddressLatitude = coordinate.latitude
                PersistenceStorage.sharedInstance.storeAddressLongitude = coordinate.longitude
                //Latitude: 34.4391609, Longitude: -118.5729441
            } else {
                print("Error fetching coordinates: \(error?.localizedDescription ?? "Unknown error")")
                PersistenceStorage.sharedInstance.storeAddressLatitude = 34.4391609
                PersistenceStorage.sharedInstance.storeAddressLongitude = -118.5729441
            }
        }
    }
}

extension LoginViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmedEmail)
    }
    func forgotPasswordAPICall(params:ForgotPasswordRequestModel,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        debugPrint(params,"forgotPasswordParams")
        debugPrint(Forgot_Password_URL,"Forgot_Password_URL")
        APIModel.postRequest(strURL: Forgot_Password_URL as NSString, postParams: params, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(ForgotPasswordResponseModel.self, from: result as! Data)
            if response?.status == 200{
                completion(response?.success ?? true,response?.message ?? "")
            }
             else {
                 completion(false,response?.message ?? "")
            }
        } failureHandler: { error in
            debugPrint(error)
            completion(false,error)
        }
    }
    func otpConfirmAPICall(params:OTPRequestModel,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        debugPrint(params,"otpParams")
        debugPrint(OTP_For_Password_URL,"OTP_For_Password_URL")
        APIModel.postRequest(strURL: OTP_For_Password_URL as NSString, postParams: params, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(OTPConfirmResponseModel.self, from: result as! Data)
            if response?.status == 200{
                completion(true,response?.message ?? "")
            }
             else {
                 completion(false,response?.message ?? "")
            }
        } failureHandler: { error in
            debugPrint(error)
            completion(false,error)
        }
    }
}
