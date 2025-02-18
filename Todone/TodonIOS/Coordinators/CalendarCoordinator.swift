//
//  CalendarCoordinator.swift
//  TodonIOS
//
//  Created by Luca Argentino on 18.02.2025.
//

import UIKit

class CalendarCoordinator: Coordinator {
    private var calendarViewController: CalendarViewController?

    func start() {
        calendarViewController = CalendarViewController()
    }

    func getViewController() -> CalendarViewController {
        calendarViewController!
    }
}
