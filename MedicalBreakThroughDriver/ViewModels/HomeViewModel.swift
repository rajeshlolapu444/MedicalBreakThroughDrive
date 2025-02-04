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
}

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
