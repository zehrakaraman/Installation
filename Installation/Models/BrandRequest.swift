//
//  BrandRequest.swift
//  Installation
//
//  Created by Zehra on 15.08.2022.
//

import Foundation

struct BrandRequest: Codable {
    var identity: String?
    var name: String?
    var maxCount: Int? = 1000
}
