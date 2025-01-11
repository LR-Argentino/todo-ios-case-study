//
//  TodoItem.swift
//  Todone
//
//  Created by Luca Argentino on 11.01.2025.
//

import Foundation


enum PriorityStatus {
    case low
    case medium
    case high
}

struct TodoItem {
    public let id: UUID
    public var title: String
    public var comment: String?
    public var priority: PriorityStatus
    public var dueDate: Date
    public let createdAt: Date
    public var users: [UUID]
}
