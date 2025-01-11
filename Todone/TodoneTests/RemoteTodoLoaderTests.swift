//
//  TodoLoaderTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 11.01.2025.
//

import XCTest

class RemoteTodoLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (RemoteTodoLoader.Error) -> Void = { _ in }) {
        self.client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}

protocol HTTPClient {
    typealias Result = Swift.Result<Data, Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

final class RemoteTodoLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURL.count, 0)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    func test_load_requestTwiceFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURL, [url, url])
    }

    func test_load_requestsDataFromURLWithCorrectURL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://example.com")!
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL.first, url)
    }
    
    func test_load_delieversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let anyError = NSError(domain: "Test", code: 0)
     
        var capturedError = [RemoteTodoLoader.Error]()
        sut.load {  capturedError.append($0)}
        
        client.completions[0](.failure(anyError))
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://example.com")!) -> (RemoteTodoLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTodoLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL = [URL]()
        var completions = [(HTTPClient.Result) -> Void]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            completions.append(completion)
            requestedURL.append(url)
        }
    }
}
