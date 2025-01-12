//
//  HTTPClient.swift
//  Todone
//
//  Created by Luca Argentino on 12.01.2025.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
