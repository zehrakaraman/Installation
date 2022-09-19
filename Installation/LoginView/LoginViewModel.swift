//
//  LoginViewModel.swift
//  Installation
//
//  Created by Zehra on 21.07.2022.
//

import Foundation

final class LoginViewModel {
    var data: ObservableObject<AccountsResponse?> = ObservableObject(nil)
    var error: ObservableObject<String?> = ObservableObject(nil)
    
    var user: User?
    var accounts: [String]?
    
    let userDefaults = UserDefaults.standard
    
    func loginWithUserInfo(username: String, password: String) {
        
        NetworkManager.shared.fetchAccounts(username: username, password: password) { [weak self] result in
            
            switch result {
            case .success(let accountsResponse):
                if accountsResponse.accounts == nil {
                    NetworkManager.shared.loginError(username: username, password: password) { [weak self] result in
                        switch result {
                        case .success(let errorResponse):
                            if Locale.current.languageCode == "tr" {
                                self?.error.value = errorResponse.tr_TR
                            } else {
                                self?.error.value = errorResponse.en_US
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    self?.data.value = accountsResponse
                    self?.user = User(username: username, password: password)
                    self?.accounts = accountsResponse.accounts
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}

