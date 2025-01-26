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
            client.complete(withStatusCode: 200, with: makeItemsJSON([item1.json]))
        }
    }
    
    func test_load_devlieversInvalidDataOnInvalidJSON() {
        let (sut, client) = makeSUT()
        let invalidData = Data("invalid".utf8)
        
        expect(sut, toCompleteWith: .failure(RemoteTodoLoader.Error.invalidData)) {
            client.complete(withStatusCode: 200, with: invalidData)
        }
    }
    
    func test_load_delieversTodoItemsOn200HTTPStatus() {
        let (sut, client) = makeSUT()
        let item1 = makeItem(title: "Case stud", comment: "test")
        let item2 = makeItem(title: "Another case", comment: "test")
        
        expect(sut, toCompleteWith: .success([item1.model, item2.model])) {
            client.complete(withStatusCode: 200, with: makeItemsJSON([item1.json, item2.json]))
        }
    }
    
    func test_load_delieversSuccessOnEmptyJSON() {
        let (sut, client) = makeSUT()
        let item = makeItemsJSON([])
        
        expect(sut, toCompleteWith: .success([])) {
            client.complete(withStatusCode: 200, with: item)
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
                    XCTAssertEqual(received.id, expected.id, "ID mismatch for item \(index + 1)", file: file, line: line)
                    XCTAssertEqual(received.title, expected.title, "Title mismatch for item \(index + 1)", file: file, line: line)
                    XCTAssertEqual(received.comment, expected.comment, "Comment mismatch for item \(index + 1)", file: file, line: line)
                    XCTAssertEqual(received.priority, expected.priority, "Priority mismatch for item \(index + 1)", file: file, line: line)
                    XCTAssertEqual(received.users, expected.users, "Users mismatch for item \(index + 1)", file: file, line: line)
//                    XCTAssertEqual(received.dueDate.formatted(date: .numeric, time: .omitted), expected.dueDate.formatted(date: .numeric, time: .omitted), "DueDate mismatch for item \(index + 1)", file: file, line: line)
//                    XCTAssertEqual(received.createdAt.formatted(date: .numeric, time: .omitted), expected.createdAt.formatted(date: .numeric, time: .omitted), "CreatedAt mismatch for item \(index + 1)", file: file, line: line)
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
    
    private func makeItem(title: String, comment: String?) -> (model: TodoItem, json: [String: Any]) {
        let item = TodoItem(
            id: UUID(),
            title: title,
            comment: comment,
            priority: PriorityStatus.low,
            dueDate: Date().addingTimeInterval(14000.0),
            users: [UUID(), UUID()]
        )

        let formatter = ISO8601DateFormatter()
        let jsonItem = [
                "id": item.id.uuidString,
                "title": item.title,
                "comment": item.comment as Any,
                "priority": item.priority,
                "dueDate": item.dueDate.dayAndTimeText,
                "createdAt": item.dueDate.dayAndTimeText,
                "users": item.users.map { $0.uuidString }
        ]
      
        
        return (item, jsonItem)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
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
        
        func complete(from url: URL = URL(string: "www.example.com")!, withStatusCode code: Int, at index: Int = 0, with data: Data = Data()) {
            let response = HTTPURLResponse(url: url, statusCode:  code, httpVersion: nil, headerFields: nil)!
            requestedURL.append(url)
            completions[index](.success((data, response)))
        }
    }
}
