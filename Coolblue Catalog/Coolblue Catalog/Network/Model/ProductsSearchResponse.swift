//
//  ProductsSearchResponse.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

/// Coolblue products search response data object
struct ProductsSearchResponse: Decodable, ContainsPaginatedMeta {

    let products: [Product]
    let currentPage: Int
    let pageSize: Int
    let totalResults: Int
    let pageCount: Int
    
}

