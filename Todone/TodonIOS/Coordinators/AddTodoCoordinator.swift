//
//  AddTodoCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class AddTodoCoordinator: Coordinator {
    private var addTodoViewController: AddTodoViewController?

    func start() {
        addTodoViewController = AddTodoViewController()
    }

    func getViewController() -> AddTodoViewController {
        addTodoViewController!
    }
}
