//
//  SessionResponse.swift
//  Installation
//
//  Created by Zehra on 3.08.2022.
//

import Foundation

struct SessionResponse: Decodable {
    var name: String?
    var uid: String?
    var sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "UserInfo$name"
        case uid = "UserInfo$uid"
        case sessionId = "UserInfo$sessionId"
    }
}
