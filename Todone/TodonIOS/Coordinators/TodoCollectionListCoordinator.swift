//
//  TodoCollectionListCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class TodoCollectionListCoordinator: Coordinator {
    private var todoCollectionListViewController: UINavigationController?

    func start() {
        let todoViewModel = TodoViewModel()
        let searchController = UISearchController(searchResultsController: nil)

        let todoListsViewController = TodoCollectionListViewController(
            viewModel: todoViewModel,
            collectionViewLayout: CollectionLayouts.makeListLayout(),
            searchController: searchController
        )

        let navigationController = UINavigationController(rootViewController: todoListsViewController)
        todoCollectionListViewController = navigationController
    }

    func getViewController() -> UINavigationController {
        todoCollectionListViewController!
    }
}
