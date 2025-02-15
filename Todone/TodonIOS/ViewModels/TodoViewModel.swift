//
//  TodoViewModel.swift
//  TodonIOS
//
//  Created by Luca Argentino on 09.02.2025.
//

import Foundation

final class TodoViewModel {
    let todos: [TodoItemViewData] = [
        TodoItemViewData(id: UUID(), title: "Test Todo 1",
                         comment: "Mein erster Test Todo ist heute da doch das will ich nicht machen vielleicht kann es wer enderer machen",
                         priority: "high",
                         isComplete: false,
                         dueDate: Date(),
                         createdAt: Date(),
                         users: []),
        TodoItemViewData(id: UUID(), title: "Use Case implementation",
                         comment: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem! Quasi, voluptates!",
                         priority: "low",
                         isComplete: true,
                         dueDate: Date().addingTimeInterval(2000),
                         createdAt: Date.now,
                         users: []),
        TodoItemViewData(id: UUID(), title: "SwiftUI",
                         priority: "medium",
                         isComplete: true,
                         dueDate: Date().addingTimeInterval(10000),
                         createdAt: Date.now,
                         users: []),
        TodoItemViewData(id: UUID(), title: "Combine",
                         priority: "medium",
                         isComplete: false,
                         dueDate: Date().addingTimeInterval(15000),
                         createdAt: Date.now,
                         users: []),
        TodoItemViewData(id: UUID(), title: "Seperate UI",
                         priority: "low",
                         isComplete: false,
                         dueDate: Date().addingTimeInterval(15000),
                         createdAt: Date.now,
                         users: [])
    ]

    func fetchTodos() -> [TodoItemViewData] {
        todos
    }
}
