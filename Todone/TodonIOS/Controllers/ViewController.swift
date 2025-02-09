//
//  ViewController.swift
//  TodonIOS
//
//  Created by Luca Argentino on 08.02.2025.
//

import UIKit

class ViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        view.backgroundColor = .white
    
    }
     
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search tasks..."
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - SearchController
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Perform methods from ViewModel
        print("DEBUG PRINT:", searchController.searchBar.text)
    }
}

