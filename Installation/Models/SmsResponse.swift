//
//  SmsResponse.swift
//  Installation
//
//  Created by Zehra on 10.08.2022.
//

import Foundation

struct SmsResponse: Decodable {
    var identity: String?
    var systemId: Int?
    
    enum CodingKeys: String, CodingKey {
        case identity = "SmsChannel$identity"
        case systemId = "SmsChannel$systemId"
    }
}
