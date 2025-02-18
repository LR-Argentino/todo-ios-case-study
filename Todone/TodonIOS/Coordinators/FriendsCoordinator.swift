//
//  FriendsCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class FriendsCoordinator: Coordinator {
    private var friendsViewController: FriendsViewController?

    func start() {
        friendsViewController = FriendsViewController()
    }

    func getViewController() -> FriendsViewController {
        friendsViewController!
    }
}
