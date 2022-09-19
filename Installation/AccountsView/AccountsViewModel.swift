//
//  AccountsViewModel.swift
//  Installation
//
//  Created by Zehra on 25.07.2022.
//

import Foundation

protocol AccountsViewModelOutputProtocol: AnyObject {
    func didUpdateAccounts()
}

protocol AccountsViewModelResponseProtocol: AnyObject {
    func didUpdateSession(session: Session)
}

final class AccountsViewModel {
    
    let userDefaults = UserDefaults.standard
    
    var user: User?
    var accounts: [String]? = []
    
    weak var accountsDelegate: AccountsViewModelOutputProtocol?
    weak var sessionDelegate: AccountsViewModelResponseProtocol?
    
    
    func loadAccounts(username: String, password: String) {
        NetworkManager.shared.fetchAccounts(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let accountsResponse):
                if let accounts = accountsResponse.accounts {
                    self?.accounts = accounts
                    self?.accountsDelegate?.didUpdateAccounts()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loginWithAccountInfo(user: User, account: String) {
        NetworkManager.shared.loginWithAccountInfo(username: user.username, accIdentity: account, password: user.password) { [weak self] result in
            switch result {
            case .success(let sessionResponse):
                if let name = sessionResponse.name, let email = sessionResponse.uid, let sessionId = sessionResponse.sessionId {
                    let session = Session(name: name, email: email, sessionId: sessionId)
                    self?.sessionDelegate?.didUpdateSession(session: session)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
