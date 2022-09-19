//
//  API.swift
//  Installation
//
//  Created by Zehra on 21.07.2022.
//

import Foundation
import Moya

enum API {
    
    case login(user: User)
    case autorization(accountRequest: AccountRequest)
    case controlImei(session: Session, serial: String)
    case controlGsm(session: Session, query: String)
    case createGsm(session: Session, simRegisterRequest: SimRegisterRequest)
    case getSms(session: Session)
    case getGprs(session: Session)
    
    case getBrands(session: Session, brandRequest: BrandRequest)
    case getModels(session: Session, modelRequest: ModelRequest)
}

extension API: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "http://takip.vektortelekom.com/fm/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "rest/user/verify/list"
        case .autorization:
            return "rest/user/session"
        case let .controlImei(_, serial):
            return "rest/montage/device/findBySerial/\(serial)"
        case .controlGsm:
            return "rest/gsm/unbinded"
        case .createGsm:
            return "rest/gsm"
        case .getSms:
            return "rest/gsm/list/smsChannel"
        case .getGprs:
            return "rest/gsm/list/gprsChannel"
        case .getBrands:
            return "rest/brand/list"
        case .getModels:
            return "rest/model/list"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .autorization, .createGsm, .getBrands, .getModels:
            return .post
        case .controlImei, .controlGsm, .getSms, .getGprs:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .login(user):
            return .requestJSONEncodable(user)
        case let .autorization(accountRequest):
            return .requestJSONEncodable(accountRequest)
        case .controlImei(_, _):
            return .requestPlain
        case let .controlGsm(_, query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        case let .createGsm(_, simRegisterRequest):
            return .requestJSONEncodable(simRegisterRequest)
        case .getSms, .getGprs:
            return .requestPlain
        case let .getBrands(_, brandRequest):
            return .requestJSONEncodable(brandRequest)
        case let .getModels(_, modelRequest):
            return .requestJSONEncodable(modelRequest)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login, .autorization:
            return ["Content-Type": "application/json"]
        case let .controlImei(session, _), let .controlGsm(session, _), let .createGsm(session, _), let .getSms(session), let .getGprs(session), let .getBrands(session, _), let .getModels(session, _):
            return ["Authorization": "\(session.sessionId)"]
        }
        
    }
    
}
