//
//  NetworkManager.swift
//  Installation
//
//  Created by Zehra on 21.07.2022.
//

import Foundation
import Moya

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var provider = MoyaProvider<API>()
    
    init() {}
    
    func fetchAccounts(username: String, password: String, completion: @escaping (Result<AccountsResponse, Error>) -> () ) {
        let user = User(username: username, password: password)
        request(target: .login(user: user), completion: completion)
    }
    
    func loginError(username: String, password: String, completion: @escaping (Result<ErrorResponse, Error>) -> () ) {
        let user = User(username: username, password: password)
        request(target: .login(user: user), completion: completion)
    }
    
    func loginWithAccountInfo(username: String, accIdentity: String, password: String, completion: @escaping (Result<SessionResponse, Error>) -> () ) {
        let accountRequest = AccountRequest(username: username, accIdentity: accIdentity, password: password)
        request(target: .autorization(accountRequest: accountRequest), completion: completion)
    }
    
    func findBySerial(session: Session, serial: String, completion: @escaping (Result<ImeiResponse, Error>) -> () ) {
        request(target: .controlImei(session: session, serial: serial), completion: completion)
    }
    
    func imeiControlError(session: Session, serial: String, completion: @escaping (Result<ErrorResponse, Error>) -> () ) {
        request(target: .controlImei(session: session, serial: serial), completion: completion)
    }
    
    func getAllGsm(session: Session, query: String, completion: @escaping (Result<GsmRepsonse, Error>) -> () ) {
        request(target: .controlGsm(session: session, query: query), completion: completion)
    }
    
    func gsmControlError(session: Session, query: String, completion: @escaping (Result<ErrorResponse, Error>) -> () ) {
        request(target: .controlGsm(session: session, query: query), completion: completion)
    }
    
    func getSms(session: Session, completion: @escaping (Result<[SmsResponse], Error>) -> () ) {
        request(target: .getSms(session: session), completion: completion)
    }
    
    func getGprs(session: Session, completion: @escaping (Result<[GprsResponse], Error>) -> () ) {
        request(target: .getGprs(session: session), completion: completion)
    }
    
    func createGsm(session: Session, simRegisterRequest: SimRegisterRequest, completion: @escaping (Result<GsmCreateResponse, Error>) -> () ) {
        request(target: .createGsm(session: session, simRegisterRequest: simRegisterRequest), completion: completion)
    }
    
    func saveSimCardError(session: Session, simRegisterRequest: SimRegisterRequest, completion: @escaping (Result<ErrorResponse, Error>) -> () ) {
        request(target: .createGsm(session: session, simRegisterRequest: simRegisterRequest), completion: completion)
    }
    
    func getBrands(session: Session, brandRequest: BrandRequest, completion: @escaping (Result<[BrandResponse], Error>) -> () ) {
        request(target: .getBrands(session: session, brandRequest: brandRequest), completion: completion)
    }
    
    func getModels(session: Session, modelRequest: ModelRequest, completion: @escaping (Result<[ModelResponse], Error>) -> () ) {
        request(target: .getModels(session: session, modelRequest: modelRequest), completion: completion)
    }
    
}

private extension NetworkManager {
    private func request<T: Decodable> (target: API, completion: @escaping (Result<T, Error>) -> () ) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}






