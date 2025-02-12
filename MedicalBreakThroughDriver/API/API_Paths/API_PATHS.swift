//
//  API_PATHS.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import Foundation
import UIKit
//MARK: - Live
let AppLive = true

let BASEURL = AppLive ? "https://yesdone.com/api/v1/" : "https://beta.yesdone.com/api/v1/"
let BUCKET_NAME =  AppLive ? "doneappai" : "doneappai-beta"
let SERVERURL = AppLive ? "https://dtzxzoe2ldz0i.cloudfront.net" : "https://d2otsz8k52dp9s.cloudfront.net"
// While uploading video to server use this URL path
let SERVERVIDEOURL = AppLive ? "https://dtzxzoe2ldz0i.cloudfront.net" : "https://d2otsz8k52dp9s.cloudfront.net"
//https://yesdone.com/api/v1/drivers/dlogin
let LOGIN_URL = BASEURL + "drivers/dlogin"
let PlaceHolderImage = UIImage(named: "logo")

//https://yesdone.com/api/v1/drivers/deliveryOrders?date=18-02-2024
let GET_ORDERS_URL = BASEURL + "drivers/deliveryOrders"
let GET_PAST_ORDERS_URL = BASEURL + "drivers/pastOrders"

//https://yesdone.com/api/v1/drivers/orders/{orderid}

let PUT_ORDER_STATUS_URL = BASEURL + "drivers/orders"

//https://yesdone.com/api/v1/drivers/driver

let GET_DRIVER_DETAILS_URL = BASEURL + "drivers/driver"


let POST_NOTES_URL = BASEURL + "drivers/notes"

let PUT_ORDER_Confirm_URL = BASEURL + "drivers/confirmDelivery"
