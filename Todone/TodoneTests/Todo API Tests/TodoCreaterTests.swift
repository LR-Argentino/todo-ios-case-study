//
//  TodoCreaterTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 28.01.2025.
//

import XCTest
import Todone

protocol TodoRepositoryProtocol {
    func save(todo: TodoItem)
}

class TodoCreater {
    let todoRepository: TodoRepositoryProtocol
    
    enum TodoCreaterError: Error {
        case emptyTitle
    }
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func create(title: String, comment: String? = nil, priority: String, dueDate: Date, users: [UUID] = []) throws {
        let isTitleEmpty = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        guard isTitleEmpty == false else {
            throw TodoCreaterError.emptyTitle
        }
        
        let todo = TodoItem(title: title, comment: comment, priority: priority, dueDate: dueDate, users: users)
        
        todoRepository.save(todo: todo)
    }
}

final class TodoCreaterTests: XCTestCase {

    func test_create_shouldAddTodoToList() {
        let mockRepository = MockTodoRepository()
        let sut = TodoCreater(todoRepository: mockRepository)
        
        try! sut.create(title: "Title", comment: "some comments", priority: "high", dueDate: Date().addingTimeInterval(10000), users: [])
        
        XCTAssertEqual(mockRepository.todos.count, 1)
    }
    
    func test_create_shouldThrowErrorOnEmptyTitle() {
        let mockRepository = MockTodoRepository()
        let sut = TodoCreater(todoRepository: mockRepository)
        
        
        XCTAssertThrowsError(try sut.create(title: "  ", comment: "some comments", priority: "high", dueDate: Date().addingTimeInterval(10000), users: []), "Title cannot be blank") { error in
            XCTAssertEqual(error as? TodoCreater.TodoCreaterError, TodoCreater.TodoCreaterError.emptyTitle)
            XCTAssertEqual(mockRepository.todos.count, 0)
        }
    }
    
    // MARK: Helper
    
    private class MockTodoRepository: TodoRepositoryProtocol {
        var todos: [TodoItem] = []
        
        func save(todo: TodoItem) {
            todos.append(todo)
        }
    }
    
}
