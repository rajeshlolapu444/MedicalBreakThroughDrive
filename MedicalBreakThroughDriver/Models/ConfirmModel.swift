//
//  ConfirmModel.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 12/02/25.
//

import Foundation

// MARK: - Confirm Delivery Reuest Model
// MARK: - deliverd/finished
struct ConfirmDeliveryRequestModel: Encodable {
    let order_id: Int?
    let status: String?
    let attachments: [AttechmentRequestModel]?
}
struct AttechmentRequestModel: Encodable {
    var attachment_type: String?
    var url: String?
}

// MARK: - rejected/cancelled
struct CancelledDeliveryRequestModel: Encodable {
    let order_id: Int?
    let status: String?
    let reason: String?
}
