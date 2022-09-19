//
//  SimRegisterRequest.swift
//  Installation
//
//  Created by Zehra on 9.08.2022.
//

import Foundation

struct SimRegisterRequest: Codable {
    var identity: String?
    var serialNumber: String?
    var pin: String?
    var pin2: String?
    var puk: String?
    var puk2: String?
    var state: String?
    var provider: String?
    var gprsChannel: Int?
    var depotId: Int?
    var smsChannel: Int?
}
