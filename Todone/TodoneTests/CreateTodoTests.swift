//
//  CreateTodoTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 26.02.2025.
//

import XCTest
import Todone

class TodoService {
    public var todos: [TodoItem] = []
    
    func create(todo: TodoItem){
        todos.append(todo)
    }
}

final class CreateTodoTests: XCTestCase {
    func test_create_createsTodoSuccessfully() async throws {
        // GIVEN
        let userSesssion = AppleAuthenticationStub.signInWithAppleSuccessfully()
        XCTAssertNotNil(userSesssion)
        
        // WHEN
        let todo = TodoItem(title: "Check for vurnerabilities", priority: "high", dueDate: Date.now.addingTimeInterval(3600), users: [])
        let todoService = TodoService()
        todoService.create(todo: todo)
        
        // THEN
        XCTAssertEqual(todoService.todos.count, 1)
    }
    
    // MARK: - Helpers
    private class AppleAuthenticationStub  {
        
        static func signInWithAppleSuccessfully() -> String {
            return "mockUserId"
        }
    }
}
