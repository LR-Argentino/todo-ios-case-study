//
//  TodoCreatorTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 28.01.2025.
//

import Todone
import XCTest

final class TodoCreatorTests: XCTestCase {
    func test_create_shouldAddTodoToList() async throws {
        let (sut, repository) = makeSUT()

        try! await sut.create(title: "Title", comment: "some comments", priority: PriorityLevel.medium, dueDate: Date().addingTimeInterval(10000), users: [])

        XCTAssertEqual(repository.todos.count, 1)
    }

    func test_create_shouldThrowErrorOnEmptyTitle() async throws {
        let (sut, repository) = makeSUT()

        do {
            _ = try await sut.create(title: "  ", comment: "some comments", priority: .high, dueDate: Date().addingTimeInterval(10000), users: [])
            XCTFail("Die Funktion hätte einen Fehler werfen sollen, hat es aber nicht.")
        } catch let error as TodoCreator.TodoCreatorError {
            XCTAssertEqual(error, .emptyTitle)
            XCTAssertEqual(repository.todos.count, 0)
        } catch {
            XCTFail("Ein unerwarteter Fehler wurde geworfen: \(error)")
        }
    }

    func test_create_shouldThrowErrorOnInvalidDate() async throws {
        try await expectErrorOnInvalidDate(deltaTime: -1000)
    }

    func test_create_shouldCreateRightTodo() async throws {
        let (sut, repository) = makeSUT()
        let expectedTodo = TodoItem(title: "Some Title", comment: "some comments", priority: PriorityLevel.high.rawValue, dueDate: Date().addingTimeInterval(10000), users: [])

        try? await sut.create(title: "Some Title", comment: "some comments", priority: PriorityLevel.high, dueDate: Date().addingTimeInterval(10000), users: [])

        XCTAssertEqual(repository.todos.first!.title, expectedTodo.title)
        XCTAssertEqual(repository.todos.first!.priority, expectedTodo.priority)
        XCTAssertEqual(repository.todos.first!.dueDate.dayAndTimeText, expectedTodo.dueDate.dayAndTimeText)
    }

    func test_create_shouldThrowErrorWhenDateIsMinusOneSecond() async throws {
        try await expectErrorOnInvalidDate(deltaTime: -1)
    }

    // MARK: Helper

    private class TodoRepositorySpy: TodoCreatorRepository {
        var todos: [TodoItem] = []

        func save(todo: TodoItem) {
            todos.append(todo)
        }
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TodoCreator, repository: TodoRepositorySpy) {
        let mockRepository = TodoRepositorySpy()
        let sut = TodoCreator(todoRepository: mockRepository)
        trackForMemoryLeaks(mockRepository, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, mockRepository)
    }

    private func expectErrorOnInvalidDate(deltaTime: TimeInterval) async throws {
        let (sut, repository) = makeSUT()
        do {
            _ = try await sut.create(title: "Some Title", comment: "some comments", priority: .high, dueDate: Date().addingTimeInterval(deltaTime), users: [])
            XCTFail("Die Funktion hätte einen Fehler werfen sollen, hat es aber nicht.")
        } catch let error as TodoCreator.TodoCreatorError {
            XCTAssertEqual(error, .invalidDate)
            XCTAssertEqual(repository.todos.count, 0)
        } catch {
            XCTFail("Ein unerwarteter Fehler wurde geworfen: \(error)")
        }
    }
}
