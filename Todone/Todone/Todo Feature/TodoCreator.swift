//
//  TodoCreator.swift
//  Todone
//
//  Created by Luca Argentino on 29.01.2025.
//

import Foundation

public enum PriorityLevel: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

// TODO: add concurrency
protocol TodoCreator {
    func create(title: String, comment: String?, priority: PriorityLevel, dueDate: Date, users: [UUID]) throws
}
