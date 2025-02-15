//
//  TodoCollectionListViewController.swift
//  TodonIOS
//
//  Created by Luca Argentino on 09.02.2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class TodoCollectionListViewController: UICollectionViewController {
    var dataSource: DataSource!
    
    let todoViewModel = TodoViewModel()
    var todos: [TodoItemViewData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        todos = todoViewModel.fetchTodos()
        
        configureDataSource()
        updateSnapshot()
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

}


// MARK: DataSource + Cell registration

extension TodoCollectionListViewController {
    enum Section {
        case main
    }
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, TodoItemViewData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TodoItemViewData>
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, TodoItemViewData> {
            (cell, indexPath, todoItemViewData) in
            let todo = self.todoViewModel.todos[indexPath.item]
            var content = cell.defaultContentConfiguration()
            let symbolName = todo.isComplete ? "checkmark.square" : "square"
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .subheadline)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
            
            content.text = todoItemViewData.title
            content.textProperties.font = .interBold16
        
            
            content.secondaryText = self.truncatedText(todoItemViewData.comment ?? "", maxWords: 5)
            content.secondaryTextProperties.numberOfLines = 1
            content.secondaryTextProperties.font = .interRegular12
            content.secondaryTextProperties.color = .secondaryLabel
            
            content.image = image
            content.imageProperties.tintColor = .systemGray4
            content.imageToTextPadding = 8

            
            content.prefersSideBySideTextAndSecondaryText = false
            cell.contentConfiguration = content
        }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(todos)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // TODO: Maybe this function goes to ViewModelEntity or ViewModel
    // TODO: Dont truncate by word, truncate by character
    private func truncatedText(_ text: String, maxWords: Int) -> String {
        let words = text.split(separator: " ")
        if words.count > maxWords {
            let truncatedWords = words.prefix(maxWords)
            return truncatedWords.joined(separator: " ") + "…"
        }
        
        return text
    }
}

