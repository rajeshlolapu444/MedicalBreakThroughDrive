//
//  SignupViewModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/03/25.
//

import Foundation
import UIKit

class SignupViewModel {
    static let shared = SignupViewModel()
    
    func signupEmailAPICall(params:SignupEmailRequestModel,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        debugPrint(params,"Params")
        let url = Create_Driver_URL as NSString
        debugPrint(url,"Create_Driver_URL")
        APIModel.postRequest(strURL: url, postParams: params, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(SignupEmailResponseModel.self, from: result as! Data)
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
    func signupVerifyOtpAPICall(params:SignupVerifyOtpRequestModel,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        debugPrint(params,"Params")
        let url = Create_Driver_Verify_OTP_URL as NSString
        debugPrint(url,"Create_Driver_Verify_OTP_URL")
        APIModel.postRequest(strURL: url, postParams: params, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(SignupEmailResponseModel.self, from: result as! Data)
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
