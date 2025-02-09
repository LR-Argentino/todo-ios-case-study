//
//  TodoCreator.swift
//  Todone
//
//  Created by Luca Argentino on 29.01.2025.
//

import Foundation

protocol CreateTodoProtocol {
    func create(title: String, comment: String?, priority: PriorityLevel, dueDate: Date, users: [UUID]) async throws
}
