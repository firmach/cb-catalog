//
//  ProductSearchViewController.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

final class ProductSearchViewController: UIViewController, CanPresentErrors {
    
    // MARK: Constants
    
    enum Strings {
        static let title = "Coolblue Catalog"
        static let searchBarPlaceholder = "search for a product"
    }
    
    // MARK: - View Model

    private var viewModel: ProductSearchViewLogic
    
    // MARK: - Private properties
    
    private var tableView = UITableView(frame: .zero)
    
    // MARK: - Initialisation

    init(viewModel: ProductSearchViewLogic) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Private methods
    
    private func initialSetup() {
        title = Strings.title
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProductCell.nib, forCellReuseIdentifier: ProductCell.className)
        tableView.register(LoadingCell.nib, forCellReuseIdentifier: LoadingCell.className)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Strings.searchBarPlaceholder
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        
        tableView.backgroundView = TableViewBackgroundView.loadFromNib()
    }
    
}

// MARK: - UITableViewDataSource

extension ProductSearchViewController: UITableViewDataSource {
    /*
     CollectionView and TableView datasources and delegates wraps in separate objects pretty often.
     I decided not to do it in case of this simple test project.
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsToDisplay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = viewModel.product(at: indexPath.row) else {
            return tableView.dequeueReusableCell(withIdentifier: LoadingCell.className, for: indexPath)
        }
        
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: ProductCell.className, for: indexPath) as? ProductCell else {
            fatalError()
        }
        
        cell.configure(for: product)
        return cell
    }
    
}

extension ProductSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = viewModel.product(at: indexPath.row) else { return }
        
        // experimental feature 😅
        if let url = URL(string: "https://www.coolblue.nl/product/\(product.productId)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ProductSearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetch(for: indexPaths.compactMap { $0.row })
    }
    
}

// MARK: - UISearchResultsUpdating

extension ProductSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.search(for: query)
        /*
         It's possible to implement some debounce logic here
         with Timer or reactive SDKs.
         */
    }

}

// MARK: - ProductSearchViewModelDelegate

extension ProductSearchViewController: ProductSearchViewModelDelegate {
    
    func updateView() {
        tableView.reloadData()
    }
    
}
