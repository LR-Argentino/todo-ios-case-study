//
//  TodoCreaterTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 28.01.2025.
//

import XCTest
import Todone

final class TodoCreatorTests: XCTestCase {

    func test_create_shouldAddTodoToList() {
        let (sut, repository) = makeSUT()
        
        try! sut.create(title: "Title", comment: "some comments", priority: PriorityLevel.medium, dueDate: Date().addingTimeInterval(10000), users: [])
        
        XCTAssertEqual(repository.todos.count, 1)
    }
    
    func test_create_shouldThrowErrorOnEmptyTitle() {
        let (sut, repository) = makeSUT()
        
        XCTAssertThrowsError(try sut.create(title: "  ", comment: "some comments", priority: PriorityLevel.high, dueDate: Date().addingTimeInterval(10000), users: []), "Title cannot be blank") { error in
            XCTAssertEqual(error as? CreateTodoUseCase.TodoCreatorError, CreateTodoUseCase.TodoCreatorError.emptyTitle)
            XCTAssertEqual(repository.todos.count, 0)
        }
    }
    
    func test_create_shouldThrowErrorOnInvalidDate() {
        let (sut, repository) = makeSUT()
        
        
        XCTAssertThrowsError(try sut.create(title: "Some Title", comment: "some comments", priority: PriorityLevel.low, dueDate: Date().addingTimeInterval(-10000), users: []), "Title cannot be blank") { error in
            XCTAssertEqual(error as? CreateTodoUseCase.TodoCreatorError, CreateTodoUseCase.TodoCreatorError.invalidDate)
            XCTAssertEqual(repository.todos.count, 0)
        }
    }
    
    func test_create_shouldCreateRightTodo() {
        let (sut, repository) = makeSUT()
        let expectedTodo = TodoItem(title: "Some Title", comment: "some comments", priority: PriorityLevel.high.rawValue, dueDate: Date().addingTimeInterval(10000), users: [])
        
        try? sut.create(title: "Some Title", comment: "some comments", priority: PriorityLevel.high, dueDate: Date().addingTimeInterval(10000), users: [])
        
        XCTAssertEqual(repository.todos.first!.title, expectedTodo.title)
        XCTAssertEqual(repository.todos.first!.priority, expectedTodo.priority)
        XCTAssertEqual(repository.todos.first!.dueDate.dayAndTimeText, expectedTodo.dueDate.dayAndTimeText)
    }
    
    // MARK: Helper
    private class TodoRepositorySpy: TodoCreatorRepository {
        var todos: [TodoItem] = []
        
        func save(todo: TodoItem) {
            todos.append(todo)
        }
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CreateTodoUseCase, repository: TodoRepositorySpy) {
        let mockRepository = TodoRepositorySpy()
        let sut = CreateTodoUseCase(todoRepository: mockRepository)
        trackForMemoryLeaks(mockRepository, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, mockRepository)
    }
    
}
