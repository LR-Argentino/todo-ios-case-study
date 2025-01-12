//
//  TodoLoaderTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 11.01.2025.
//

import XCTest
import Todone

final class RemoteTodoLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURL.count, 0)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    func test_load_requestTwiceFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURL, [url, url])
    }

    func test_load_requestsDataFromURLWithCorrectURL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://example.com")!
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURL.first, url)
    }
    
    func test_load_delieversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let anyError = NSError(domain: "Test", code: 0)
     
        var capturedError = [RemoteTodoLoader.Error]()
        sut.load { result in
            switch result {
            case .failure(let error):
                capturedError.append(error as! RemoteTodoLoader.Error)
            default:
                XCTFail()
            }
        }
        
        client.complete(with: anyError)
        XCTAssertEqual(capturedError , [.connectivity])
    }
    
    func test_load_delieversErrorOnNon200HTTPStatus() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://example.com")!
        let statusCodes = [199, 300, 400, 500]
        
        var capturedError = [RemoteTodoLoader.Error]()
        
        
        statusCodes.enumerated().forEach { index, statusCode in
            sut.load() { result in
                switch result {
                case .failure(let error):
                    capturedError.append(error as! RemoteTodoLoader.Error)
                default:
                    XCTFail()
                }
            }
            client.complete(from: url, withStatusCode: statusCode, at: index)
            XCTAssertEqual(capturedError, [.invalidData])
            capturedError.removeLast()
        }
        
    }
    
    
    func test_load_delieversCorrectDataOn200HTTPStatus() {
        let (sut, client) = makeSUT()
        let item1 = makeItem(title: "Case stud", comment: "test")
        
        expect(sut, toCompleteWith: .success([item1.model])) {
            client.complete(from: URL(string: "https://example.com")!, withStatusCode: 200, with: item1.json)
        }
    }
    
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://example.com")!, file: StaticString = #file, line: UInt = #line) -> (RemoteTodoLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTodoLoader(client: client, url: url)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
                        
    private func expect(_ sut: RemoteTodoLoader, toCompleteWith expectedResult: RemoteTodoLoader.Result, whem action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { recievedResult in
            switch (recievedResult, expectedResult) {
                case let (.success(recievedItems), .success(expectedItems)):
                for (index, (received, expected)) in zip(recievedItems, expectedItems).enumerated() {
                    // Überprüfung der genauen Übereinstimmung der Date-Objekte
                    XCTAssertEqual(received.id, expected.id, "ID mismatch for item \(index + 1)")
                    XCTAssertEqual(received.title, expected.title, "Title mismatch for item \(index + 1)")
                    XCTAssertEqual(received.comment, expected.comment, "Comment mismatch for item \(index + 1)")
                    XCTAssertEqual(received.priority, expected.priority, "Priority mismatch for item \(index + 1)")
                    XCTAssertEqual(received.users, expected.users, "Users mismatch for item \(index + 1)")
                    XCTAssertEqual(received.dueDate.formatted(date: .numeric, time: .omitted), expected.dueDate.formatted(date: .numeric, time: .omitted), "DueDate mismatch for item \(index + 1)")
                    XCTAssertEqual(received.createdAt.formatted(date: .numeric, time: .omitted), expected.createdAt.formatted(date: .numeric, time: .omitted), "CreatedAt mismatch for item \(index + 1)")
                }
            case let (.failure(recievedError as RemoteTodoLoader.Error), .failure(expectedError as RemoteTodoLoader.Error)):
                XCTAssertEqual(recievedError , expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) but got \(recievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeItem(title: String, comment: String?) -> (model: TodoItem, json: Data) {
        let item = TodoItem(
            id: UUID(),
            title: title,
            comment: comment,
            priority: "low",
            dueDate: Date(),
            createdAt: Date(),
            users: [UUID(), UUID()]
        )

        let formatter = ISO8601DateFormatter()
        let jsonArray: [[String: Any]] = [
            [
                "id": item.id.uuidString,
                "title": item.title,
                "comment": item.comment as Any,
                "priority": item.priority,
                "dueDate": formatter.string(from: item.dueDate),
                "createdAt": formatter.string(from: item.createdAt),
                "users": item.users.map { $0.uuidString }
            ]
        ]
        let jsonItem = try! JSONSerialization.data(withJSONObject: jsonArray)
        
        return (item, jsonItem)
    }
    
        
    private class HTTPClientSpy: HTTPClient {
        var requestedURL = [URL]()
        var completions = [(HTTPClient.Result) -> Void]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            completions.append(completion)
            requestedURL.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        func complete(from url: URL, withStatusCode code: Int, at index: Int = 0, with data: Data = Data()) {
            let response = HTTPURLResponse(url: url, statusCode:  code, httpVersion: nil, headerFields: nil)!
            requestedURL.append(url)
            completions[index](.success((data, response)))
        }
    }
}
