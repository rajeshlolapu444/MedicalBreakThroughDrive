//
//  ConfirmViewModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 12/02/25.
//

import Foundation
import UIKit

class ConfirmViewModel {
    static let shared = ConfirmViewModel()
    
    func putOrdersConfirmAPI(parms:ConfirmDeliveryRequestModel, completion: @escaping (_ status:Bool, _ msg:String?) -> Void) {
        let url = PUT_ORDER_Confirm_URL
        debugPrint(url,"PUT_ORDER_Confirm_URL")
        debugPrint(parms,"putParams")
        APIModel.putRequest(strURL: url as NSString, postParams: parms, postHeaders: headers as NSDictionary) { result in
            let response = try? JSONDecoder().decode(PutStatusResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                completion(true,response?.message ?? "")
            } else {
                completion(false,response?.message ?? "")
            }
        } failureHandler: { error in
            completion(false,error)
        }
    }
    func putOrdersCancellAPI(parms:CancelledDeliveryRequestModel, completion: @escaping (_ status:Bool, _ msg:String?) -> Void) {
        let url = PUT_ORDER_Confirm_URL
        debugPrint(url,"PUT_ORDER_Confirm_URL")
        debugPrint(parms,"putParams")
        APIModel.putRequest(strURL: url as NSString, postParams: parms, postHeaders: headers as NSDictionary) { result in
            let response = try? JSONDecoder().decode(PutStatusResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                completion(true,response?.message ?? "")
            } else {
                completion(false,response?.message ?? "")
            }
        } failureHandler: { error in
            completion(false,error)
        }
    }
}
