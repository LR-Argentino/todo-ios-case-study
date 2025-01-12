//
//  RemoteTodoItem.swift
//  Todone
//
//  Created by Luca Argentino on 12.01.2025.
//

import Foundation

public struct RemoteTodoItem: Decodable {
    public let id: UUID
    public var title: String
    public var comment: String?
    public var priority: String
    public var dueDate: Date
    public let createdAt: Date
    public var users: [UUID]
    
}
