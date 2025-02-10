//
//  ViewController.swift
//  TodonIOS
//
//  Created by Luca Argentino on 08.02.2025.
//

import UIKit

class ViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let todoListViewController = TodoCollectionListViewController(collectionViewLayout: CollectionLayouts.makeListLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        view.backgroundColor = .white
        
        // Schritt 1: Child VC hinzufügen
       addChild(todoListViewController)
       
       // Schritt 2: View des Child-VCs hinzufügen
       view.addSubview(todoListViewController.view)
       
       // Schritt 3: Constraints für todoListViewController.view
       todoListViewController.view.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
           todoListViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           todoListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           todoListViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           todoListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
       
       // Schritt 4: Abschließen, damit UIKit weiß, dass der Child-VC korrekt eingebunden wurde
       todoListViewController.didMove(toParent: self)
    
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

