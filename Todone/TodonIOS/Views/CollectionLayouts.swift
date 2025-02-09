//
//  CollectionLayouts.swift
//  TodonIOS
//
//  Created by Luca Argentino on 09.02.2025.
//

import UIKit

struct CollectionLayouts {
    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.backgroundColor = .white
        listConfiguration.showsSeparators = false
    
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
