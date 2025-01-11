//
//  TodoLoader.swift
//  Todone
//
//  Created by Luca Argentino on 11.01.2025.
//

import Foundation

protocol TodoLoader {
    func loadTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
}
