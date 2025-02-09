//
//  LoadTodoProtocol.swift
//  Todone
//
//  Created by Luca Argentino on 02.02.2025.
//

import Foundation

protocol LoadTodoProtocol {
    func load() async throws -> [TodoItem]
}
