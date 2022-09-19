//
//  GsmAssignRequest.swift
//  Installation
//
//  Created by Zehra on 23.08.2022.
//

import Foundation

struct GsmAssignRequest: Codable {
    var deviceIdentity: String?
    var oldGsmIdentity: String?
    var newGsmIdentity: String?
}
