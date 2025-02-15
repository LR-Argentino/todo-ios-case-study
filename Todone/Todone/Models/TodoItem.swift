//
//  TodoItem.swift
//  Todone
//
//  Created by Luca Argentino on 11.01.2025.
//

import Foundation

public struct TodoItem: Equatable, Identifiable {
    public let id: UUID = .init()
    public var title: String
    public var comment: String?
    public var priority: String
    public var dueDate: Date
    public var isComplete: Bool
    public let createdAt: Date
    public var users: [UUID]

    public init(title: String, comment: String? = nil, priority: String, isComplete: Bool = false, dueDate: Date, users: [UUID]) {
        self.title = title
        self.comment = comment
        self.priority = priority
        self.isComplete = isComplete
        self.users = users
        createdAt = Date.now
        self.dueDate = dueDate
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#if DEBUG
    public extension TodoItem {
        static var sampleData: [TodoItem] {
            [
                TodoItem(title: "Use Case", priority: "low", dueDate: Date().addingTimeInterval(3600), users: []),
                TodoItem(title: "API", priority: "medium", dueDate: Date().addingTimeInterval(7200), users: []),
                TodoItem(title: "UI", priority: "high", dueDate: Date().addingTimeInterval(10800), users: []),
                TodoItem(title: "Testing", priority: "high", dueDate: Date().addingTimeInterval(14400), users: []),
            ]
        }
    }
#endif
