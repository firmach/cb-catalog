//
//  Product.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import Foundation

/// Coolblue product model
struct Product: Decodable {
    
    struct ReviewInformation: Decodable {
        struct ReviewSummary: Decodable {
            let reviewAverage: Double
            let reviewCount: Int
        }
        
        let reviewSummary: ReviewSummary
    }
    
    struct PromoIcon: Decodable {
        let text: String
        let type: String
    }
    
    let productId: Int
    let productName: String
    let reviewInformation: ReviewInformation
    let usps: [String]
    let availabilityState: Int
    let salesPriceIncVat: Decimal
    let productImage: String
    let coolbluesChoiceInformationTitle: String?
    let promoIcon: PromoIcon?
    let nextDayDelivery: Bool
    
    enum CodingKeys: String, CodingKey {
        case productId
        case productName
        case reviewInformation
        case usps = "USPs"
        case availabilityState
        case salesPriceIncVat
        case productImage
        case coolbluesChoiceInformationTitle
        case promoIcon
        case nextDayDelivery
    }
}

