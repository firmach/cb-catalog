//
//  ProductService.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

/// Product service protocol
protocol ProductService {

    /// Search for product with a query text
    func search(for textToSearchFor: String, page: Int) async -> Result<ProductsSearchResponse, Error>

}

/// Product service implementation
struct ProductServiceImpl: ProductService {

    // MARK: Private Properties

    private let apiClient: HTTPClient

    // MARK: - Initializer

    init(apiClient: HTTPClient) {
        self.apiClient = apiClient
    }

    // MARK: - ProductService

    func search(for textToSearchFor: String, page: Int) async -> Result<ProductsSearchResponse, Error> {
        return await apiClient.request(endpoint: SearchProductEndpoint(searchString: textToSearchFor, page: page))
    }

}
