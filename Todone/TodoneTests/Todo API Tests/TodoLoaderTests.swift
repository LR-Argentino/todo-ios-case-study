//
//  TodoLoaderTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 29.01.2025.
//

import Todone
import XCTest

final class TodoLoaderTests: XCTestCase {
   
    func test_load_shouldCallLoadMethodOnce() async throws{
        let repository = TodoRepositoryMock()
        let sut = TodoLoader(repository: repository)
        
        _ = try await sut.load()
        
        XCTAssertEqual(repository.callCount, 1)
    }
    
    func test_load_shouldReturnTodosOnSuccess() async throws {
        let repository = TodoRepositoryMock()
        let sut = TodoLoader(repository: repository)
        let items = [TodoItem(title: "Title", priority: "low", dueDate: Date().addingTimeInterval(3600), users: [])]
        
        repository.fillTodos(items)
        
        _ = try await sut.load()
        
        XCTAssertEqual(repository.todos, items)
    }
    
    func test_load_shouldThrowErrorOnFailure() async throws {
        let repository = TodoRepositoryMock()
        let sut = TodoLoader(repository: repository)
        
        do {
            repository.loadTodosFailWithError(NSError(domain: "", code: 0, userInfo: nil))
            _ = try await sut.load()
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    private class TodoRepositoryMock: TodoLoaderRepository {
        var callCount = 0
        var error: Error?
        var todos: [TodoItem] = []
        
        func fetch() async throws -> [Todone.TodoItem] {
            callCount += 1
            if error != nil {
                throw error!
            }
            return todos
        }
        
        func fillTodos(_ todos: [TodoItem]) {
            self.todos = todos
        }
        
        func loadTodosFailWithError(_ error: Error) {
            self.error = error
        }
    }
}
