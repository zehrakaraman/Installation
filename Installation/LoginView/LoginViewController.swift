//
//  LoginViewController.swift
//  Installation
//
//  Created by Zehra on 21.07.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    let viewModel = LoginViewModel()
    
    var checked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let username = viewModel.userDefaults.string(forKey: "username") ?? ""
        let password = viewModel.userDefaults.string(forKey: "password") ?? ""
        
        if username !=  "" && password != "" {
            viewModel.loginWithUserInfo(username: username, password: password)
        }
        
        setupBinders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.designTextFields(textFields: [emailField, passwordField])
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAccountsView" {
            if let user = sender as? AllInfoOfUser {
                let destinationVC = segue.destination as! AccountsViewController
                destinationVC.viewModel.user = user.user
                destinationVC.viewModel.accounts = user.accounts
            }
        }
    }
    
    private func setupBinders() {
        viewModel.data.bind { [weak self] data in
            guard let self = self else {return}
            if data != nil {
                if self.checked == true {
                    self.viewModel.userDefaults.set(self.emailField.text, forKey: "username")
                    self.viewModel.userDefaults.set(self.passwordField.text, forKey: "password")
                }
                
                let loader = self.loader(message: "Please, wait.")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.stopLoader(loader: loader)
                    if let user = self.viewModel.user, let accounts = self.viewModel.accounts {
                        let allInfoOfUser = AllInfoOfUser(user: user, accounts: accounts)
                        self.performSegue(withIdentifier: "toAccountsView", sender: allInfoOfUser)
                    }
                }
            } else {
                self.viewModel.error.bind { [weak self] error in
                    if let error = error {
                        self?.showErrorMessage(error: error)
                    }
                }
            }
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, ddont do anything
            return
        }
        
        var shouldMoveViewUp = false
        
        let bottomOfLoginBtn = loginBtn.convert(loginBtn.bounds, to: self.view).maxY
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        if bottomOfLoginBtn > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        if shouldMoveViewUp {
            // move to root view up by the distance of keyboard height
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back to root view origin to zero
        self.view.frame.origin.y = 0
    }

    @IBAction func rememberTapped(_ sender: UIButton) {
        if checked {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            checked = false
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            checked = true
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = emailField.text, let password = passwordField.text else {
            print("Datas couldn't be read.")
            return
        }
        viewModel.loginWithUserInfo(username: username, password: password)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.emailField:
            self.passwordField.becomeFirstResponder()
        default:
            self.passwordField.resignFirstResponder()
        }
    }
    
}



