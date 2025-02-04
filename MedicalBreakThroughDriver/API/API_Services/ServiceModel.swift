//
//  ServiceModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import Foundation
import UIKit
import SystemConfiguration

//MARK:-  Reachability Use For Checking Tha Internet Connection Available are not
var appDelegate = UIApplication.shared.delegate as! AppDelegate
let content_type = "application/json; charset=utf-8"
var APIModel = ServiceModel()

class ServiceModel: NSObject {
    
    var window: UIWindow?
    var task : URLSessionTask?
    
    // MARK: - POST REQUEST
    func postRequest(strURL:NSString,postParams:Encodable,postHeaders:NSDictionary,successHandler:@escaping( _ result:Any)->Void,failureHandler:@escaping (_ error:String)->Void) -> Void {
        if isConnectedToNetwork() == false {
           // showToast(message: "Please Check Internet")
            return
        }
      //  LoaderView.shared.showLoader(in: self.view)
        let urlStr:NSString = strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)! as NSString
        let url: NSURL = NSURL(string: urlStr as String)!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField:"Content-Type")
        request.addValue("application/json",forHTTPHeaderField:"Accept")
        if postHeaders["Authorization"] != nil  {
        }
        
        if let authToken = UserDefaults.standard.string(forKey: k_token) {
            request.setValue("Bearer" + " " + authToken,forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(postParams)
        }
        catch {
        }
        task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            DispatchQueue.main.async(){
                if response != nil {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if statusCode == 401 {
                        failureHandler("unAuthorized")
                    }
                    if statusCode == 500 {
                        failureHandler("unAuthorized")
                    }
                    if statusCode == 422 {
                        failureHandler("Something went wrong. Please try again later.")
                    }
                    else if error != nil
                    {
                        return
                    }
                    else {
                        do {
                            let parsedData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String:Any]
                            debugPrint(parsedData)
                            successHandler(data! as NSData)
                        } catch let error as NSError {
                            debugPrint("error=\(error)")
                            return
                        }
                    }
                }
            }
        }
        task?.resume()
    }
    // MARK: - GET REQUEST
    func getRequest(strURL:String,postHeaders:NSDictionary,success:@escaping(_ result:Any)->Void,failure:@escaping(_ error:String) -> Void) {
        if isConnectedToNetwork() == false {
            //print("Please Check Internet")
            /*DesignModel.stopActivityIndicator*/()
       //     showToastforInterNet(message: "Please Check Internet")
            return
        }
        
        let fileUrl = NSURL(string: strURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
        let request = NSMutableURLRequest(url: fileUrl! as URL)
        request.addValue(content_type, forHTTPHeaderField: "Content-Type")
        request.addValue(content_type, forHTTPHeaderField: "Accept")
        
        request.httpMethod = "GET"
        if postHeaders["Authorization"] != nil  {
        }
        if let authToken = UserDefaults.standard.string(forKey: k_token) {
            request.setValue("Bearer" + " " + authToken,forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 999999
        
        task = URLSession.shared.dataTask(with:request as URLRequest){(data,response,error) in
            DispatchQueue.main.async(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                })
                if response != nil {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if statusCode == 401 {
                        failure("unAuthorized")
                    }
                    if statusCode == 500 {
                        failure("unAuthorized")
                    }
                    if statusCode == 404 {
                        failure("Enter Valid Credentials")
                    }
                    else if error != nil
                    {
                    }
                    else
                    {
                        do{
                            let parsedData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String:Any]
                            debugPrint(parsedData)
                            success(data! as NSData)
                        }
                        catch{
                            failure("error")
                            return
                        }
                    }
                }
                else{
                }
            }
        }
        task?.resume()
    }
    // MARK: - PUT REQUEST
    func putRequest(strURL:NSString,postParams:Encodable,postHeaders:NSDictionary,successHandler:@escaping( _ result:Any)->Void,failureHandler:@escaping (_ error:String)->Void) -> Void {
        if isConnectedToNetwork() == false {
          //  showToastforInterNet(message: "Please Check Internet")
            return
        }
        let urlStr:NSString = strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)! as NSString
        let url: NSURL = NSURL(string: urlStr as String)!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        request.httpMethod = "PUT"
        request.addValue("application/json",forHTTPHeaderField:"Content-Type")
        request.addValue("application/json",forHTTPHeaderField:"Accept")
        if postHeaders["Authorization"] != nil  {
        }
        
        if let authToken = UserDefaults.standard.string(forKey: k_token) {
            request.setValue("Bearer" + " " + authToken,forHTTPHeaderField: "Authorization")
        }
        
        task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            DispatchQueue.main.async(){
                if response != nil {
                    // Response Status Code
                 //   let statusCode = (response as! HTTPURLResponse).statusCode
//                    if statusCode == 401 {
//                        failureHandler("unAuthorized")
//                    }
//                    if statusCode == 400 {
//                        failureHandler("nvalid order or order cannot be accepted")
//                    }
//                    if statusCode == 500 {
//                        //print("failuer 1")
//                        failureHandler("unAuthorized")
//                    } else if statusCode == 422 {
//                        failureHandler("Phone number already exists")
//                    }
//                    else if error != nil
//                    {
//                        return
//                    }
//                    else {
                        do {
                            let parsedData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String:Any]
                            debugPrint(parsedData)
                            successHandler(data! as NSData)
                        } catch let error as NSError {
                            debugPrint("error=\(error)")
                            return
                        }
                    }
                }
           // }
        }
        task?.resume()
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
