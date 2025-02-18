//
//  TabBarCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class TabBarCoordinator: Coordinator {
    private var tabBarController: UITabBarController
    private var childCoordinators: [Coordinator] = []

    init() {
        tabBarController = UITabBarController()
    }

    func start() {
        tabBarController.viewControllers = [
            setupTodoListBarItem(),
            setupCalendarBarItem(),
            setupAddTodoBarItem(),
            setupFriendsBarItem(),
            setupSettingsBarItem()
        ]
    }

    func getTabBarController() -> UITabBarController {
        tabBarController
    }
}

// MARK: - Setup Tabbar Items

extension TabBarCoordinator {
    private func setupTodoListBarItem() -> UINavigationController {
        let todoListCoordinator = TodoCollectionListCoordinator()

        childCoordinators.append(todoListCoordinator)

        todoListCoordinator.start()

        let todoListNavigationController = todoListCoordinator.getViewController()

        // TODO: Change later to NSlocale
        todoListNavigationController.title = "Todos"
        todoListNavigationController.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        todoListNavigationController.tabBarItem.selectedImage = UIImage(
            systemName: "list.bullet.clipboard.fill")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        todoListNavigationController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        return todoListNavigationController
    }

    private func setupCalendarBarItem() -> UIViewController {
        let calendarCoordinator = CalendarCoordinator()

        childCoordinators.append(calendarCoordinator)

        calendarCoordinator.start()

        let calendarViewController = calendarCoordinator.getViewController()

        // TODO: Change later to NSlocale
        calendarViewController.title = "Calendar"
        calendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
        calendarViewController.tabBarItem.selectedImage = UIImage(systemName: "calendar")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        calendarViewController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        return calendarViewController
    }

    private func setupAddTodoBarItem() -> UIViewController {
        let addTodoCoordinator = AddTodoCoordinator()

        childCoordinators.append(addTodoCoordinator)

        addTodoCoordinator.start()

        let addTodoViewController = addTodoCoordinator.getViewController()

        // TODO: Change later to NSlocale
        addTodoViewController.title = "Add Todo"
        addTodoViewController.tabBarItem.image = UIImage(systemName: "plus.circle")
        addTodoViewController.tabBarItem.selectedImage = UIImage(systemName: "plus.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        addTodoViewController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        return addTodoViewController
    }

    private func setupFriendsBarItem() -> UIViewController {
        let friendsCoordinator = FriendsCoordinator()

        childCoordinators.append(friendsCoordinator)

        friendsCoordinator.start()

        let friendsViewController = friendsCoordinator.getViewController()

        // TODO: Change later to NSlocale
        friendsViewController.title = "Friends"
        friendsViewController.tabBarItem.image = UIImage(systemName: "person.3")
        friendsViewController.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        friendsViewController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        return friendsViewController
    }

    private func setupSettingsBarItem() -> UIViewController {
        let settingsCoordinator = SettingsCoordinator()

        childCoordinators.append(settingsCoordinator)

        settingsCoordinator.start()

        let settingsViewController = settingsCoordinator.getViewController()

        // TODO: Change later to NSlocale
        settingsViewController.title = "Settings"
        settingsViewController.tabBarItem.image = UIImage(systemName: "gear")
        settingsViewController.tabBarItem.selectedImage = UIImage(systemName: "gear")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        settingsViewController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)

        return settingsViewController
    }
}
