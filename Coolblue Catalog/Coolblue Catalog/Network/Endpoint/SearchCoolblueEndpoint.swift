//
//  SearchCoolblueEndpoint.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

/// Endpoint for Coolblue search request
struct SearchProductEndpoint: CoolblueEndpoint {
    typealias Content = ProductsSearchResponse

    let searchString: String
    let page: Int
    var path: String { "/mobile-assignment/search" }
    var method: HTTPMethod { .get }
    var queryItems: [String : String] { ["page": String(page), "query": searchString] }
}
