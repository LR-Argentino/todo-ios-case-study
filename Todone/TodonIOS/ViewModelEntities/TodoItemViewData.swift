//
//  TodoItemViewData.swift
//  TodonIOS
//
//  Created by Luca Argentino on 09.02.2025.
//

import Foundation

struct TodoItemViewData: Hashable {
    public let id: UUID
    public var title: String
    public var comment: String?
    public var priority: String
    public var dueDate: Date
    public let createdAt: Date
    public var users: [UUID]
}
