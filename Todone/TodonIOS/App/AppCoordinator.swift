//
//  AppCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - Coordinator Implementation

extension AppCoordinator: Coordinator {
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()

        let tabBarViewController = tabBarCoordinator.getTabBarController()
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()

        childCoordinators.append(tabBarCoordinator)
    }
}
