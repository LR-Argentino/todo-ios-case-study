//
//  test.swift
//  TodoneTests
//
//  Created by Luca Argentino on 12.01.2025.
//

import XCTest
import FirebaseFirestore

class FirestoreMock {
    public var collectionName: String?
    
    @discardableResult
    func collection(_ name: String) -> Self{
        collectionName = name
        return self
    }
    
    
    func getDocuments(source: FirestoreSource = .default, completion: @escaping (Error) -> Void) {
        switch source {
        case .cache, .default:
            let error = NSError(domain: "", code: 0)
            completion(error)
        default:
            break;
        }
    }
}

class FirestoreClient {
    private let store: FirestoreMock
    
    init(store: FirestoreMock) {
        self.store = store
    }
    
    func get(from url: URL, completion: @escaping (Error) -> Void) {
        store.collection(url.absoluteString).getDocuments { error in
            completion(error)
        }
    }
}

final class FirebaseFirestoreClientTests: XCTestCase {

    func test_getFrom_callsRightCollection() {
        let firestoreMock = FirestoreMock()
        let sut = FirestoreClient(store: firestoreMock)
        let collection = "items"
        
        sut.get(from: URL(string: collection)!) { _ in }
        
        XCTAssertEqual(firestoreMock.collectionName, collection)
    }
    
    func test_getFrom_returnErrorWhenCacheMechanismIsAvialableOnGetDocuments() {
        let firestoreMock = FirestoreMock()
        let sut = FirestoreClient(store: firestoreMock)
        
        var capturedError: Error?
        
        sut.get(from: URL(string: "items")!) { capturedError = $0}
        
        XCTAssertNotNil(capturedError)
    }
//    private func configureEmulator() -> Firestore {
   //        if FirebaseApp.app() == nil {
   //           FirebaseApp.configure()
   //        }
   //        let firestore = Firestore.firestore()
   //        let settings = firestore.settings
   //        settings.host = "localhost:8080" // Firestore Emulator Host und Port
   //        settings.isSSLEnabled = false // Kein SSL für den Emulator
   //        firestore.settings = settings
   //        firestore.collection("items").getDocuments(source: .de, completion: <#T##(QuerySnapshot?, (any Error)?) -> Void#>)
   //        return firestore
   //     }
}
