//
//  ServiceLayer.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

// Network layer entry point
enum ServiceLayer {

    // In case of real world project it should be something more complex than an enum.
    // Solution will depend on project functional requirements.

    /// Products service
    static var productService: ProductService { ProductServiceImpl(apiClient: ApiClient()) }
}
