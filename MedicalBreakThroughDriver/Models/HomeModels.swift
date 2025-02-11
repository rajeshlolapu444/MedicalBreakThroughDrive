//
//  HomeModels.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 11/02/25.
//

import Foundation

// MARK: - OrdersResponseModel
struct OrdersResponseModel: Codable {
    let message: String?
    let status: Int?
    let data: OrdersData?
}

// MARK: - DataClass
struct OrdersData: Codable {
    let orders: [Order]?
    let pagination: Pagination?
}

// MARK: - Order
struct Order: Codable {
    let id, orderID, amount: Int?
    let transactionID: String?
    let phone, deliveryInstructions: String?
    let status, createdAt: String?
    let customer: Customer?
    let address: Address?
    let products: [Product]?
    let deliveryDetails: DeliveryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case amount
        case transactionID = "transaction_id"
        case phone
        case deliveryInstructions = "delivery_instructions"
        case status
        case createdAt = "created_at"
        case customer, address, products
        case deliveryDetails = "delivery_details"
    }
}

// MARK: - Address
struct Address: Codable {
    let id: Int?
    let addressLine1: String?
    let addressLine2: String?
    let city, state, country, postalCode: String?
    let latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case id
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city, state, country
        case postalCode = "postal_code"
        case latitude, longitude
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int?
    let firstName, lastName, name, phone: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case name, phone
    }
}

// MARK: - DeliveryDetails
struct DeliveryDetails: Codable {
    let id, deliveryPersonID: Int?
    let status: String?
    let notes: String?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case id
        case deliveryPersonID = "delivery_person_id"
        case status, notes, images
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
    }
}

// MARK: - Product
struct Product: Codable {
    let productID: Int?
    let productName: String?
    let productImage: String?
    let productPrice: String?
    let quantity: Int?


    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case productImage = "product_image"
        case productPrice = "product_price"
        case quantity
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let total, perPage, currentPage, lastPage: Int?
    let nextPageURL, prevPageURL: String?
    let url: URLClass?

    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
        case url
    }
}

// MARK: - URLClass
struct URLClass: Codable {
    let path: String?
    let pageName: String?
}


// MARK: - Notes Post Request Model
struct NotesRequestModel: Encodable {
    let order_id: Int?
    let notes: String?
}
// MARK: - Notes Response Model
struct NotesResponseModel: Codable {
    let message: String?
    let status: Int?
}

// MARK: - PUT Request Model
struct PutStatusRequestModel: Encodable {
    let status: String?
  //  let reason: String?
//    "status": "finished",
//      "reason": "Reason for completed remarks"

}

// MARK: - PUT Response Model
struct PutStatusResponseModel: Codable {
    let message: String?
    let status: Int?
}
