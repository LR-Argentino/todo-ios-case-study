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
    
    private static var OK_200: Int {
        return 200
    }
    
    static func map(from: Data, response: HTTPURLResponse) throws -> [RemoteTodoItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: from) else {
            throw RemoteTodoLoader.Error.invalidData
        }
        return root.items
    }
}
