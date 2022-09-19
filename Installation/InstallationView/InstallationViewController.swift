//
//  InstallationViewController.swift
//  Installation
//
//  Created by Zehra on 13.08.2022.
//

import UIKit

class InstallationViewController: UIViewController {

    @IBOutlet weak var licancePlateLabel: UITextField!
    @IBOutlet weak var brandBtn: UIButton!
    @IBOutlet weak var modelBtn: UIButton!
    @IBOutlet weak var fuelTypeBtn: UIButton!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var deviceTypeBtn: UIButton!
    @IBOutlet weak var kilometerLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    
    let viewModel = InstallationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getBrands()
        setupBinders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.designTextFields(textFields: [licancePlateLabel, kilometerLabel, descriptionLabel])
        
        navigationItem.hidesBackButton = true
        
        let navController = navigationController!
        let image = UIImage(named: "vektor")
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        let imageView = UIImageView(frame: CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(NewInstallationViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(NewInstallationViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension InstallationViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, ddont do anything
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.btnBottomConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.btnBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func setupBinders() {
        self.viewModel.brands.bind { [weak self] data in
            if let data = data {
                self?.createBrandsMenu(items: data, button: (self?.brandBtn)!)
            }
        }
        
        self.viewModel.models.bind { [weak self] data in
            if let data = data {
                self?.createModelsMenu(items: data, button: (self?.modelBtn)!)
            }
        }
    }
    
    func createBrandsMenu(items: [BrandResponse], button: UIButton) {
        var children: [UIAction] = []
        
        items.forEach { item in
            let item = UIAction(title: item.name!) { (action) in
                let loader = self.loader(message: "Models are loading.")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    
                    self.stopLoader(loader: loader)
                    
                    button.setTitle(item.name, for: .normal)
                    if let systemId = item.systemId {
                        self.viewModel.getModels(brand: systemId)
                    }
                }
                
            }
            children.append(item)
            
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: children)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
    
    func createModelsMenu(items: [ModelResponse], button: UIButton) {
        var children: [UIAction] = []
        
        items.forEach { item in
            let item = UIAction(title: item.name!) { (action) in
                button.setTitle(item.name, for: .normal)
                self.createFuelTypesMenu()
            }
            children.append(item)
    
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: children)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
    
    func createFuelTypesMenu() {
        
        let fuelTypes = [
            "Gas",
            "Diesel"
        ]
        
        var children: [UIAction] = []
        
        fuelTypes.forEach { item in
            let item = UIAction(title: item) { (action) in
                self.fuelTypeBtn.setTitle(item, for: .normal)
                self.createYearsMenu()
            }
            
            children.append(item)
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: children)
        self.fuelTypeBtn.menu = menu
        self.fuelTypeBtn.showsMenuAsPrimaryAction = true
        
    }
    
    func createYearsMenu() {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        var children: [UIAction] = []
        
        for year in stride(from: (currentYear + 1), to: 1969, by: -1) {
            let item = UIAction(title: "\(year)") { (action) in
                self.yearBtn.setTitle("\(year)", for: .normal)
            }
            children.append(item)
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: children)
        self.yearBtn.menu = menu
        self.yearBtn.showsMenuAsPrimaryAction = true
    }
}
