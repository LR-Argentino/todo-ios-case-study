//
//  TodoRepositoryProtocol.swift
//  Todone
//
//  Created by Luca Argentino on 28.01.2025.
//

import Foundation

public protocol TodoCreatorRepository {
    func save(todo: TodoItem) async throws
}
