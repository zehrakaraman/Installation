//
//  ImeiResponse.swift
//  Installation
//
//  Created by Zehra on 8.08.2022.
//

import Foundation

struct ImeiResponse: Decodable {
    var failureList: [FailureList]?
    var subId: String?
    var unit: String?
    var assetIdentity: String?
    var assetId: Int?
    var clientState: String?
    var gsmAccount: String?
    var subIdentity: String?
    var events: [FailureList]?
    var clientIdentity: String?
}

struct FailureList: Decodable {
    var identity: String
    var en_US: String
    var tr_TR: String
}
