//
//  Extensions.swift
//  Installation
//
//  Created by Zehra on 27.07.2022.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    func loader(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        indicator.color = UIColor(named: "textColor")
        alert.view.addSubview(indicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader: UIAlertController)  {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
    
    func showErrorMessage(error: String) {
        let errorMessage = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString(error, comment: ""), preferredStyle: .alert)
        let okeyBtn = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default)
        errorMessage.addAction(okeyBtn)
        present(errorMessage, animated: true, completion: nil)
    
    }
    
    func designTextFields(textFields: [UITextField]) {
        textFields.forEach {
            $0.delegate = self
            if #available(iOS 13.0, *) {
                $0.overrideUserInterfaceStyle = .light
            }
        }
    }
    
}
