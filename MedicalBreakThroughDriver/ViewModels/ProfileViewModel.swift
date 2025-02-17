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
    func changePasswordAPICall(params:ChangePasswordRequestModel,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        debugPrint(params,"params")
        debugPrint(Change_Password_URL,"Change_Password_URL")
        APIModel.postRequest(strURL: Change_Password_URL as NSString, postParams: params, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(ChangePasswordResponseModel.self, from: result as! Data)
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



