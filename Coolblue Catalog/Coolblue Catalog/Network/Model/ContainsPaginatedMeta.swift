//
//  ContainsPaginatedMeta.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

/// Describes objects that contains paginated response
protocol ContainsPaginatedMeta {
    
    var currentPage: Int { get }
    var pageSize: Int { get }
    var totalResults: Int { get }
    var pageCount: Int { get }
    
}
