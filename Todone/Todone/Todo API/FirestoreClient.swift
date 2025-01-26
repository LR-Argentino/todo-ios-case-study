////
////  FirestoreClient.swift
////  Todone
////
////  Created by Luca Argentino on 14.01.2025.
////
//
//
//
//
//class FirestoreClient: HTTPClient {
//    private let store: Firestore
//    private let FETCH_MECHANISM = FirestoreSource.server
//    
//    init(store: Firestore) {
//        self.store = store
//    }
//    
//    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
//        let keyPath = url.lastPathComponent
//        store.collection(url.lastPathComponent).getDocuments(source: FETCH_MECHANISM) { (querySnapshot, error) in
//            if let capturedError = error  {
//                completion(.failure(capturedError))
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else {
//                let error = NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No documents found."])
//                completion(.failure(error))
//                return
//            }
//            
//            do {
//                let data = try JSONSerialization.data(withJSONObject: [keyPath: documents.map { $0.data() }], options: [])
//                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
//                completion(.success((data, response)))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
//}
