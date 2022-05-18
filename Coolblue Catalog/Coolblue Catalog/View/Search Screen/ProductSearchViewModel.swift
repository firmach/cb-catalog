//
//  ProductSearchViewModel.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import Foundation

/// Product Search view model
protocol ProductSearchViewLogic {
    
    var delegate: (ProductSearchViewModelDelegate & CanPresentErrors)? { get set }
    
    /// Shows that not all products are already loaded
    var hasMoreToLoad: Bool { get }
    
    /// How many rows we need to display.
    ///
    /// This includes `LoadingCell` if needed
    var rowsToDisplay: Int { get }
    
    /// Begin search with a given query
    func search(for query: String)
    
    /// Returns product at index.
    ///
    /// Returns nil if index is bigger than number of already loaded products
    func product(at index: Int) -> Product?
    
    /// Asks view model to prefetch more products
    func prefetch(for indexes: [Int])
}

/// Product Search Screen view model delegate
protocol ProductSearchViewModelDelegate: AnyObject {
    
    /*
     We can achieve the same result by using reactive programming.
     But in case of simple test project
     I've decided to use a simpler solution with a delegate protocol.
     */
    
    /// Search results update has arrived
    ///
    /// Please, update the UI now. Should be done on main thread.
    @MainActor func updateView()
    
}

/// Product Search view model implementation
final class ProductSearchViewModel: ProductSearchViewLogic {
    
    // MARK: Public Properties

    weak var delegate: (ProductSearchViewModelDelegate & CanPresentErrors)?
    var hasMoreToLoad: Bool { total > foundItems.count }
    var rowsToDisplay: Int { hasMoreToLoad ? foundItems.count + 1 : total }

    // MARK: - Private Properties

    private var foundItems: [Product] = []
    
    /// Current search query
    private var currentQuery: String = ""
    /// Total amount of products for current query
    private var total = 0
    /// Current loaded page number
    private var currentPage = 0

    /// Current request task
    private var dataTask: Task<Void, Never>?
    
    // MARK: - Network Service

    /// Network service
    private let service: ProductService

    // MARK: - Init

    /// Initialize view model with a given service
    init(service: ProductService) {
        self.service = service
    }
    
    // MARK: - Private methods
    
    private func obtain(page: Int, for query: String) {
        guard query.count >= 2 else { return }

        dataTask?.cancel()

        dataTask = Task(priority: .utility) {
            let result = await service.search(for: query, page: page)
            switch result {
            case .failure(let error):
                await delegate?.showError(error)
            case .success(let response):
                foundItems.append(contentsOf: response.products)
                total = response.totalResults
                currentPage = response.currentPage
                await delegate?.updateView()
            }
        }
    }
    
    // MARK: - Public methods
    
    @MainActor func search(for query: String) {
        currentPage = 1
        foundItems = []
        total = 0
        delegate?.updateView()
        currentQuery = query
        obtain(page: currentPage, for: query)
    }
    
    func product(at index: Int) -> Product? {
        guard index < foundItems.count else { return nil }
        return foundItems[index]
    }
    
    func prefetch(for indexes: [Int]) {
        guard hasMoreToLoad else { return }
        if indexes.contains(where: { $0 > (foundItems.count - 1) }) {
            obtain(page: currentPage + 1, for: currentQuery)
        }
    }
    
}
