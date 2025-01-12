//
//  RemotTodoItemMapper.swift
//  Todone
//
//  Created by Luca Argentino on 12.01.2025.
//

import Foundation


public final class RemoteTodoItemMapper {
    struct Root: Decodable {
        // "items" because the API Response is: "items": [ {data} ]
        let items: [RemoteTodoItem]
    }
    static func map(from: Data, response: HTTPURLResponse) throws -> [RemoteTodoItem] {
        let decoder = JSONDecoder()
        // TODO: Change the strategy based on Current location
        decoder.dateDecodingStrategy = .iso8601
        guard response.statusCode == 200,
              let root = try? decoder.decode(Root.self, from: from) else {
            throw RemoteTodoLoader.Error.invalidData
        }
        return root.items
    }
}
