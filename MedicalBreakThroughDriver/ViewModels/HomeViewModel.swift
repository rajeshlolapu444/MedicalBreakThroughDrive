//
//  HomeViewModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import Foundation
import UIKit

class HomeViewModel {
    static let shared = HomeViewModel()
    
    func getOrdersListAPI(date: String?, completion: @escaping (_ data:[Order]?,_ status:Bool, _ msg:String?) -> Void) {
        let url = GET_ORDERS_URL + "?date=\(date ?? "")"
        debugPrint(url,"GET_ORDERS_URL")
        APIModel.getRequest(strURL:url, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(OrdersResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                completion(response?.data?.orders,true,"")
            } else {
                completion([],false,response?.message ?? "")
            }
        } failure: { error in
            completion([],false,error)
        }
    }
    func getActiveOrdersListAPI(start_date: String?,end_date: String?, completion: @escaping (_ data:[Order]?,_ status:Bool, _ msg:String?) -> Void) {
        let url = GET_ORDERS_URL //+ "?start_date=\(start_date ?? "")&end_date=\(end_date ?? "")"
        debugPrint(url,"GET_ORDERS_URL")
        APIModel.getRequest(strURL:url, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(OrdersResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                completion(response?.data?.orders,true,"")
            } else {
                completion([],false,response?.message ?? "")
            }
        } failure: { error in
            completion([],false,error)
        }
    }
    func getPastOrdersListAPI(start_date: String?,end_date: String?, completion: @escaping (_ data:[Order]?,_ status:Bool, _ msg:String?) -> Void) {
        let url = GET_PAST_ORDERS_URL //+ "?start_date=\(start_date ?? "")&end_date=\(end_date ?? "")"
        debugPrint(url,"GET_PAST_ORDERS_URL")
        APIModel.getRequest(strURL:url, postHeaders: ["":""]) { result in
            let response = try? JSONDecoder().decode(OrdersResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                completion(response?.data?.orders,true,"")
            } else {
                completion([],false,response?.message ?? "")
            }
        } failure: { error in
            completion([],false,error)
        }
    }
    func notesAPICall(id:Int?,notes:String?,completion: @escaping (_ status:Bool, _ msg:String?) -> Void){
        let notesParams = NotesRequestModel(order_id: id ?? 0, notes: notes ?? "")
        debugPrint(notesParams,"notesParams")
        debugPrint(POST_NOTES_URL,"POST_NOTES_URL")
        APIModel.postRequest(strURL: POST_NOTES_URL as NSString, postParams: notesParams, postHeaders: ["":""]) { result in
            let notesResponse = try? JSONDecoder().decode(NotesResponseModel.self, from: result as! Data)
            if notesResponse?.status == 200{
                completion(true, notesResponse?.message)
            }
            else {
                completion(false, notesResponse?.message)
            }
        } failureHandler: { error in
            debugPrint(error)
            completion(false,error)
        }
    }
    func putOrdersStatusAPI(orderId: Int?,status: String?, completion: @escaping (_ status:Bool, _ msg:String?) -> Void) {
        let url = PUT_ORDER_STATUS_URL + "/\(orderId ?? 0)"
        debugPrint(url,"PUT_ORDER_STATUS_URL")
        let putParams = PutStatusRequestModel(status: status)
        debugPrint(putParams,"putParams")
        APIModel.putRequest(strURL: url as NSString, postParams: putParams, postHeaders: headers as NSDictionary) { result in
            let response = try? JSONDecoder().decode(PutStatusResponseModel.self, from: result as! Data)
            if response?.status == 200 {
                completion(true,"")
            } else {
                completion(false,response?.message ?? "")
            }
        } failureHandler: { error in
            completion(false,error)
        }
    }
}

