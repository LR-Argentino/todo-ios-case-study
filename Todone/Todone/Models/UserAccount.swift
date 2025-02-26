//
//  UserAccount.swift
//  Todone
//
//  Created by Luca Argentino on 26.02.2025.
//

import Foundation

struct UserAccount {
    public let id: UUID = UUID()
    public let appleUserID: String
    public var name: String
    public var lastName: String
    public var email: String
}
