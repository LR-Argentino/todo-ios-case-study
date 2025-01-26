//
//  TodoItem.swift
//  Todone
//
//  Created by Luca Argentino on 11.01.2025.
//

import Foundation


public enum PriorityStatus: String, Codable {
    case low
    case medium
    case high
}

public struct TodoItem: Equatable {
    public let id: UUID
    public var title: String
    public var comment: String?
    public var priority: PriorityStatus
    public var dueDate: Date
    public let createdAt: Date
    public var users: [UUID]
    
    public init(id: UUID, title: String, comment: String? = nil, priority: PriorityStatus, dueDate: Date, users: [UUID]) {
        self.id = id
        self.title = title
        self.comment = comment
        self.priority = priority
        self.users = users
        self.createdAt = Date.now
        self.dueDate = dueDate
    }
}
