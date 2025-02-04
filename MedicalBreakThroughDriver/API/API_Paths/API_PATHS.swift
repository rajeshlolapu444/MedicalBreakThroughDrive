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
//https://yesdone.com/api/v1/drivers/dlogin
let LOGIN_URL = BASEURL + "drivers/dlogin"

//https://yesdone.com/api/v1/drivers/deliveryOrders?date=18-02-2024
let GET_ORDERS_URL = BASEURL + "drivers/deliveryOrders"

//https://yesdone.com/api/v1/drivers/orders/{orderid}

let PUT_ORDER_STATUS_URL = BASEURL + "drivers/orders"
