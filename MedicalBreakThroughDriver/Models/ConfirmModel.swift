//
//  ConfirmModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 12/02/25.
//

import Foundation

// MARK: - Confirm Delivery Reuest Model
// MARK: - deliverd/finished
struct ConfirmDeliveryRequestModel: Codable {
    let order_id: Int?
    let status: String?
    let attachments: [AttechmentRequestModel]?
}
struct AttechmentRequestModel: Codable {
    var attachment_type: String?
    var url: String?
}

// MARK: - rejected/cancelled
struct CancelledDeliveryRequestModel: Codable {
    let order_id: Int?
    let status: String?
    let reason: String?
}
