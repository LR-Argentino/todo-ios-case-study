//
//  RemoteTodoLoader.swift
//  Todone
//
//  Created by Luca Argentino on 12.01.2025.
//
import Foundation

public final class RemoteTodoLoader: TodoLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = TodoLoader.Result
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data,response)):
                completion(RemoteTodoLoader.map(from: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(from data: Data, response: HTTPURLResponse) -> TodoLoader.Result {
        do {
            let items = try RemoteTodoItemMapper.map(from: data, response: response)
            return .success(items.toModels())
        } catch {
            return .failure(Error.invalidData)
        }
    }
}

extension Array where Element == RemoteTodoItem {
    func toModels() -> [TodoItem] {
        return map {
            TodoItem(id: $0.id, title: $0.title, comment: $0.comment, priority: $0.priority, dueDate: $0.dueDate, createdAt: $0.createdAt, users: $0.users)
        }
    }
}
