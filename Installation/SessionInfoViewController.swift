//
//  SessionInfoViewController.swift
//  Installation
//
//  Created by Zehra on 8.08.2022.
//

import UIKit

class SessionInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var session: Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = session?.name
        emailLabel.text = session?.email
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
