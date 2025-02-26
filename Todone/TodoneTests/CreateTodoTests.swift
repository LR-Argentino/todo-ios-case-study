//
//  CreateTodoTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 26.02.2025.
//

import XCTest
import Todone

final class CreateTodoTests: XCTestCase {
    func test_create_createsTodoSuccessfully() async throws {
        // GIVEN
        let userSesssion = AppleAuthenticationStub.signInWithAppleSuccessfully()
        XCTAssertNotNil(userSesssion)
        
        // WHEN
        let todo = TodoItem(title: "Check for vurnerabilities", priority: "high", dueDate: Date.now.addingTimeInterval(3600), users: [])
        let todoService = TodoService()
        try await todoService.create(todo: todo)
        
        // THEN
        XCTAssertEqual(todos.count, 1)
    }
}
