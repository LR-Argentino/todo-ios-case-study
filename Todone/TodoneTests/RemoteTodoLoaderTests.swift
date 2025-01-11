//
//  TodoLoaderTests.swift
//  TodoneTests
//
//  Created by Luca Argentino on 11.01.2025.
//

import XCTest

class RemoteTodoLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(from url: URL) {
        self.client.load(from: url)
    }
}

protocol HTTPClient {
    func load(from url: URL)
}

final class RemoteTodoLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURL.count, 0)
    }
    
    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://example.com")!
        
        sut.load(from: url)
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    func test_load_requestTwiceFromURL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://example.com")!
        
        sut.load(from: url)
        sut.load(from: url)
        
        XCTAssertEqual(client.requestedURL.count, 2)
    }

    
    // MARK: Helpers
    
    private func makeSUT() -> (RemoteTodoLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTodoLoader(client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL = [URL]()
        
        func load(from url: URL) {
            requestedURL.append(url)
        }
    }
}
