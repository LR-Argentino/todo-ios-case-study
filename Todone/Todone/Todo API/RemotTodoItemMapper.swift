//
//  RemotTodoItemMapper.swift
//  Todone
//
//  Created by Luca Argentino on 12.01.2025.
//

import Foundation


public final class RemoteTodoItemMapper {
    static func map(from: Data, response: HTTPURLResponse) throws -> [RemoteTodoItem] {
        let decoder = JSONDecoder()
              decoder.dateDecodingStrategy = .iso8601
        guard response.statusCode == 200,
              let root = try? decoder.decode([RemoteTodoItem].self, from: from) else {
            throw RemoteTodoLoader.Error.invalidData
        }
        return root
    }
}