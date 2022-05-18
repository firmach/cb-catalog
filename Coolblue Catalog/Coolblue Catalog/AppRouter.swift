//
//  AppRouter.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

/// App Router
///
/// This object controls user's flow
/// and configures screens for this flow
final class AppRouter {

    /// Builds root screen of the app
    func buildRootScreen() -> UIViewController {
        let productSearchViewModel = ProductSearchViewModel(service: ServiceLayer.productService)
        
        let productSearchViewController = ProductSearchViewController(viewModel: productSearchViewModel)
        
        let navigationController = UINavigationController(rootViewController: productSearchViewController)

        return navigationController
    }

}
