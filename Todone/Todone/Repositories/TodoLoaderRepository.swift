//
//  TodoLoaderRepository.swift
//  Todone
//
//  Created by Luca Argentino on 02.02.2025.
//

public protocol TodoLoaderRepository {
    func fetch() async throws -> [TodoItem]
}
