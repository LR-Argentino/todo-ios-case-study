//
//  TodoCreator.swift
//  Todone
//
//  Created by Luca Argentino on 28.01.2025.
//

import Foundation

public class TodoCreator: CreateTodoProtocol {
    let todoRepository: TodoCreatorRepository

    public enum TodoCreatorError: Error {
        case emptyTitle
        case invalidDate
    }

    public init(todoRepository: TodoCreatorRepository) {
        self.todoRepository = todoRepository
    }

    public func create(title: String, comment: String? = nil, priority: PriorityLevel, dueDate: Date, users: [UUID] = []) async throws {
        let isTitleEmpty = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isDateInPast = dueDate < Date.now

        guard !isTitleEmpty else {
            throw TodoCreatorError.emptyTitle
        }

        guard !isDateInPast else {
            throw TodoCreatorError.invalidDate
        }

        let todo = TodoItem(title: title, comment: comment, priority: priority.rawValue, dueDate: dueDate, users: users)

        do {
            try await todoRepository.save(todo: todo)
        } catch {
            throw error
        }
    }
}
