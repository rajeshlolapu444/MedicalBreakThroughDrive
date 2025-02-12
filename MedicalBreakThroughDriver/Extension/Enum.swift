//
//  Enum.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 04/02/25.
//

import Foundation
import UIKit

enum DeliveryStatus: String {
    //case accepted = "accepted"
    //case started = "started"
    case delivered = "delivered"
   // case finished = "finished"
    case rejected = "rejected"
    case none
}
enum MediaType {
    case image
    case video
} 

enum OrdersType {
    case Active
    case Past
}
