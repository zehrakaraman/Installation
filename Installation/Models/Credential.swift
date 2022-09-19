//
//  Credential.swift
//  Installation
//
//  Created by Zehra on 21.07.2022.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
}

struct AllInfoOfUser: Codable {
    var user: User
    var accounts: [String]
}

struct Session: Codable {
    var name: String
    var email: String
    var sessionId: String
}


