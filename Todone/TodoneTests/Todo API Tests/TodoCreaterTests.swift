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
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func create(title: String, comment: String? = nil, priority: String, dueDate: Date, users: [UUID] = []) {
        let todo = TodoItem(title: title, comment: comment, priority: priority, dueDate: dueDate, users: users)
        
        todoRepository.save(todo: todo)
    }
}

final class TodoCreaterTests: XCTestCase {

    func test_create_shouldAddTodoToList() {
        let mockRepository = MockTodoRepository()
        let sut = TodoCreater(todoRepository: mockRepository)
        
        sut.create(title: "Title", comment: "some comments", priority: "high", dueDate: Date().addingTimeInterval(10000), users: [])
        
        XCTAssertEqual(mockRepository.todos.count, 1)
    }
    
    // MARK: Helper
    
    private class MockTodoRepository: TodoRepositoryProtocol {
        var todos: [TodoItem] = []
        
        func save(todo: TodoItem) {
            todos.append(todo)
        }
    }
    
}
