//
//  TodoLoader.swift
//  Todone
//
//  Created by Luca Argentino on 02.02.2025.
//

import Foundation

public class TodoLoader: LoadTodoProtocol {
    private let repository: TodoLoaderRepository
    
    public init(repository: TodoLoaderRepository) {
        self.repository = repository
    }
    
    public func load() async throws -> [TodoItem] {
        do {
            return try await self.repository.fetch()
        } catch {
            throw error
        }
    }
}
