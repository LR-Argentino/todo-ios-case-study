//
//  TodoLoaderTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 29.01.2025.
//

import Todone
import XCTest

protocol TodoLoaderRepository {
    func fetchTodos() async throws -> [TodoItem]
}

class LoadTodosUseCase {
    let loaderRepository: TodoLoaderRepository

    init(loaderRepository: TodoLoaderRepository) {
        self.loaderRepository = loaderRepository
    }

    func load() async throws -> [TodoItem] {
        return try await loaderRepository.fetchTodos()
    }
}

final class TodoLoaderTests: XCTestCase {
    func test_load_shouldReturnNothingOnEmptyTodos() async throws {
        let (sut, _) = makeSUT()

        let loadedTodos = try await sut.load()

        XCTAssertEqual(loadedTodos, [])
    }

    func test_load_shouldReturnTodosOnCorrectOrder() async throws {
        let (sut, loader) = makeSUT()

        loader.loadTodos()
        
        let loadedTodos = try await sut.load()
        
        XCTAssertNotNil(loadedTodos)
        XCTAssertEqual(loadedTodos.count, 3)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: LoadTodosUseCase, loader: MockTodoLoaderRepository) {
        let repository = MockTodoLoaderRepository()
        let sut = LoadTodosUseCase(loaderRepository: repository)

        return (sut, repository)
    }

    private class MockTodoLoaderRepository: TodoLoaderRepository {
        private var todos: [TodoItem] = []
        func fetchTodos() -> [TodoItem] {
            return todos
        }
        
        func loadTodos() {
            todos = createTodos()
        }
        
        private func createTodos() -> [TodoItem] {
            return [
                TodoItem(id: UUID(), title: "Some Todo", priority: "low", dueDate: Date().addingTimeInterval(3600), users: []),
                TodoItem(id: UUID(), title: "Another Todo", priority: "high", dueDate: Date().addingTimeInterval(7200), users: []),
                TodoItem(id: UUID(), title: "Yet Another Todo", priority: "medium", dueDate: Date().addingTimeInterval(10800), users: [UUID(), UUID()]),
            ]
        }
    }

   
}
