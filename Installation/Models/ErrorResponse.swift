//
//  ErrorResponse.swift
//  Installation
//
//  Created by Zehra on 5.08.2022.
//

import Foundation

struct ErrorResponse: Decodable {
    var en_US: String?
    var tr_TR: String?
    var error: String?
    var message: String?
}

