//
//  AccountsViewController.swift
//  Installation
//
//  Created by Zehra on 25.07.2022.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var accountsList: UITableView!
    
    let viewModel = AccountsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsList.delegate = self
        accountsList.dataSource = self
        
        viewModel.accountsDelegate = self
        viewModel.sessionDelegate = self
        
        accountsList.estimatedRowHeight = 50
        accountsList.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.designTextFields(textFields: [accountsList])
        
        [accountsList].forEach {
            $0?.delegate = self
            if #available(iOS 13.0, *) {
                $0?.overrideUserInterfaceStyle = .light
            }
        }
        
        navigationItem.hidesBackButton = true
        
        navigationItem.title = "Accounts"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor")!]
        
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    @IBAction func exitTapped(_ sender: Any) {
        viewModel.userDefaults.removeObject(forKey: "username")
        viewModel.userDefaults.removeObject(forKey: "password")
        
        exit(-1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeView" {
            if let session = sender as? Session {
                let destinationVC = segue.destination as! HomeViewController
                destinationVC.viewModel.session = session
            }
        }
    }
    
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.accounts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = viewModel.accounts![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountsListTableViewCell
        
        let separators = CharacterSet(charactersIn: ",")
        let accountResult = account.components(separatedBy: separators)
        
        let first = accountResult[1]
        let firstResult = first.components(separatedBy: CharacterSet(charactersIn: "="))
        
        let second = accountResult[2]
        let secondResult = second.components(separatedBy: CharacterSet(charactersIn: "="))
        
        cell.accountLabel.text = "\(firstResult[1]) -> \(secondResult[1])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let user = viewModel.user, let accounts = viewModel.accounts {
            //let account = viewModel.accounts![indexPath.row]
            viewModel.loginWithAccountInfo(user: user, account: accounts[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        
        }
        
    }
    
}

extension AccountsViewController: AccountsViewModelOutputProtocol {
    
    func didUpdateAccounts() {
        accountsList.reloadData()
    }
    
}

extension AccountsViewController: AccountsViewModelResponseProtocol {
    
    func didUpdateSession(session: Session) {
        
        let loader = self.loader(message: "Please, wait.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.stopLoader(loader: loader)
            self.performSegue(withIdentifier: "toHomeView", sender: session)
        }
        
    }
    
}



