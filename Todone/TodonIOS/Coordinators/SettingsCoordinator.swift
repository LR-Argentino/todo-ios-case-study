//
//  SettingsCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class SettingsCoordinator: Coordinator {
    private var settingsViewController: SettingsViewController?

    func start() {
        settingsViewController = SettingsViewController()
    }

    func getViewController() -> SettingsViewController {
        settingsViewController!
    }
}
