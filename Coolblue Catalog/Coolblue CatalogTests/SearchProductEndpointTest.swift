//
//  SearchProductEndpointTest.swift
//  Coolblue CatalogTests
//
//  Created by Roman Churkin on 18.05.2022.
//

import XCTest
@testable import Coolblue_Catalog

class SearchProductEndpointTest: XCTestCase {

    let endpoint = SearchProductEndpoint(searchString: "abc", page: 1)
    
    func testRequest() throws {
        let request = try endpoint.request
        
        guard let method = request.httpMethod else {
            return XCTFail("No HTTP method in request")
        }
        XCTAssertEqual(method, "GET", "Wrong HTTP method in request")
        
        guard let url = request.url else {
            return XCTFail("No URL in request")
        }
        XCTAssertEqual(url.path, "/mobile-assignment/search", "Wrong path in request")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return XCTFail("No components found in URL")
        }
        guard let queryItems = components.percentEncodedQueryItems else {
            return XCTFail("URL doesn't contain any components")
        }
        let expectedItems = [URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "query", value: "abc")]
        XCTAssertEqual(
            queryItems.sorted(by: { $0.name < $1.name }),
            expectedItems.sorted(by: { $0.name < $1.name }),
            "Wrong query components"
        )
    }
    
    func testResponse() throws {
        let data = """
        {
            "products": [
                {
                    "productId": 785359,
                    "productName": "Apple iPhone 6 32GB Grijs",
                    "reviewInformation": {
                        "reviews": [],
                        "reviewSummary": {
                            "reviewAverage": 9.1,
                            "reviewCount": 952
                        }
                    },
                    "USPs": [
                        "32 GB opslagcapaciteit",
                        "4,7 inch Retina HD scherm",
                        "iOS 11"
                    ],
                    "availabilityState": 2,
                    "salesPriceIncVat": 369,
                    "productImage": "https://image.coolblue.nl/300x750/products/818870",
                    "coolbluesChoiceInformationTitle": "middenklasse iPhone",
                    "promoIcon": {
                        "text": "middenklasse iPhone",
                        "type": "coolblues-choice"
                    },
                    "nextDayDelivery": true
                }
            ],
            "currentPage": 1,
            "pageSize": 24,
            "totalResults": 70,
            "pageCount": 3
        }
        """.data(using: .utf8)!
        
        let content = try endpoint.content(from: data)
        
        XCTAssertEqual(1, content.currentPage)
        XCTAssertEqual(24, content.pageSize)
        XCTAssertEqual(70, content.totalResults)
        XCTAssertEqual(3, content.pageCount)
        
        let product = content.products.first!
        XCTAssertEqual(785359, product.productId)
        XCTAssertEqual("Apple iPhone 6 32GB Grijs", product.productName)
        XCTAssertEqual(2, product.availabilityState)
        XCTAssertEqual(369, product.salesPriceIncVat)
        XCTAssertEqual("https://image.coolblue.nl/300x750/products/818870", product.productImage)
        XCTAssertEqual("middenklasse iPhone", product.coolbluesChoiceInformationTitle)
        XCTAssertEqual(true, product.nextDayDelivery)

        let usps = product.usps
        XCTAssertEqual(usps, [
            "32 GB opslagcapaciteit",
            "4,7 inch Retina HD scherm",
            "iOS 11"
        ])
        
        let reviewSummary = product.reviewInformation.reviewSummary
        XCTAssertEqual(9.1, reviewSummary.reviewAverage)
        XCTAssertEqual(952, reviewSummary.reviewCount)
    }

}
