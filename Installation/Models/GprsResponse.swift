//
//  GprsResponse.swift
//  Installation
//
//  Created by Zehra on 10.08.2022.
//

import Foundation

struct GprsResponse: Decodable {
    var identity: String?
    var systemId: Int?
    
    enum CodingKeys: String, CodingKey {
        case identity = "GprsChannel$identity"
        case systemId = "GprsChannel$systemId"
    }
}
