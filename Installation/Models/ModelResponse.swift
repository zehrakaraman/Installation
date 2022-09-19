//
//  ModelResponse.swift
//  Installation
//
//  Created by Zehra on 15.08.2022.
//

import Foundation

struct ModelResponse: Decodable {
    var systemId: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case systemId = "VehicleModel$systemId"
        case name = "VehicleModel$name"
    }
}
