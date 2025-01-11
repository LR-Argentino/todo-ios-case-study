//
//  TodoLoader.swift
//  Todone
//
//  Created by Luca Argentino on 11.01.2025.
//

import Foundation

protocol TodoLoader {
    typealias Result = Swift.Result<[TodoItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
