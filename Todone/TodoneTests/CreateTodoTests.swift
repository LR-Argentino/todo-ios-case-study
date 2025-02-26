//
//  CreateTodoTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 26.02.2025.
//

import XCTest
import Todone


protocol TodoRepositoryProtocol {
    func save(todo: TodoItem)
}

protocol TodoServiceProtocol {
    func create(todo: TodoItem)
}

class TodoService: TodoServiceProtocol {
    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func create(todo: TodoItem){
        self.todoRepository.save(todo: todo)
    }
}

final class CreateTodoTests: XCTestCase {
    func test_create_createsTodoSuccessfully() async throws {
        // GIVEN
        let userSesssion = AppleAuthenticationStub.signInWithAppleSuccessfully()
        let repository = CoreDataRepositoryMock()
        let todoService = TodoService(todoRepository: repository)
        let todo = TodoItem(title: "Check for vurnerabilities", priority: "high", dueDate: Date.now.addingTimeInterval(3600), users: [])
        
        // WHEN
        todoService.create(todo: todo)
        
        // THEN
        XCTAssertEqual(repository.todos.count, 1)
    }
    
    // MARK: - Helpers
    private class AppleAuthenticationStub  {
        
        static func signInWithAppleSuccessfully() -> String {
            return "mockUserId"
        }
    }
    
    private class CoreDataRepositoryMock: TodoRepositoryProtocol {
        public var todos: [TodoItem] = []
        
        func save(todo: TodoItem) {
            todos.append(todo)
        }
    }
}
