//
//  BrandResponse.swift
//  Installation
//
//  Created by Zehra on 15.08.2022.
//

import Foundation

struct BrandResponse: Decodable {
    var systemId: Int?
    var identity: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case systemId = "VehicleBrand$systemId"
        case identity = "VehicleBrand$identity"
        case name = "VehicleBrand$name"
    }
}
