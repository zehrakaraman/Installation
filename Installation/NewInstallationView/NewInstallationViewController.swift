//
//  NewInstallationViewController.swift
//  Installation
//
//  Created by Zehra on 1.08.2022.
//

import UIKit

class NewInstallationViewController: UIViewController {
    
    @IBOutlet weak var imeiLabel: UITextField!
    @IBOutlet weak var gsmLabel: UITextField!
    
    @IBOutlet weak var simSaveView: UIView!
    @IBOutlet weak var gprsChannelLabel: UITextField!
    @IBOutlet weak var smsChannelLabel: UITextField!
    @IBOutlet weak var didActiveLabel: UILabel!
    
    @IBOutlet weak var selectOperatorsBtn: UIButton!
    
    @IBOutlet weak var saveBarcodeBtn: UIButton!
    
    let viewModel = NewInstallationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.controlDelegate = self
        
        if !viewModel.didControlImei {
            self.gsmLabel.isUserInteractionEnabled = false
        }
        
        //self.navigationController?.isToolbarHidden = true
        
        if let QRCode = viewModel.QRCode {
            self.imeiLabel.text = QRCode
        }
        
        setupBinders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.designTextFields(textFields: [imeiLabel, gsmLabel, gprsChannelLabel, smsChannelLabel])
        
        self.simSaveView.isHidden = true
        
        createOperatorsMenu()
        
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
        
//        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
//        NotificationCenter.default.addObserver(self, selector: #selector(NewInstallationViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
//        NotificationCenter.default.addObserver(self, selector: #selector(NewInstallationViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSessionInfo" {
            if let session = sender as? Session {
                let destinationVC = segue.destination as! SessionInfoViewController
                destinationVC.session = session
            }
        }
        
        if segue.identifier == "toInstallation" {
            if let session = sender as? Session {
                let destinationVC = segue.destination as! InstallationViewController
                destinationVC.viewModel.session = session
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func showSessionInfo(_ sender: Any) {
        
        if let session = viewModel.session {
            performSegue(withIdentifier: "toSessionInfo", sender: session)
        }
        
    }
    
    @IBAction func openScannerBtn(_ sender: Any) {
        performSegue(withIdentifier: "toScanner", sender: nil)
    }
    
    @IBAction func controlImei(_ sender: Any) {
        if let serial = self.imeiLabel.text {
            self.viewModel.controlImei(serial: serial)
        }
    }
    
    @IBAction func controlGsm(_ sender: Any) {
        
        if !viewModel.didControlImei {
            self.showErrorMessage(error: "Please, control the imei.")
        } else {
            self.simSaveView.isHidden = false
            
            if let phoneNumber = self.gsmLabel.text {
                let query = self.viewModel.fixPhoneNumber(phoneNumber: phoneNumber)
                self.viewModel.controlGsm(query: query)
            }
        }
        
    }
    
    @IBAction func saveSimCard(_ sender: Any) {
        
        let simRegisterResponse = createGsm()
        viewModel.createGsm(simRegisterRequest: simRegisterResponse)
        
    }
    
    @IBAction func saveBarcode(_ sender: Any) {
        if self.viewModel.systemId != nil {
            performSegue(withIdentifier: "toInstallation", sender: viewModel.session)
        }
        
    }
    
}

extension NewInstallationViewController: NewInstallationViewModelControlProtocol {
    
    func controlImei() {
        self.viewModel.didControlImei = true
        self.gsmLabel.isUserInteractionEnabled = true
    }
    
}

extension NewInstallationViewController: NewInstallationViewModelGsmProtocol {
    
    func getGsm() -> String? {
        guard let gsm = self.gsmLabel.text else {
            return nil
        }
        return gsm
    }
}

extension NewInstallationViewController {
    
    func setupBinders() {
        
        self.viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error: error)
            }
        }
        
        
        self.viewModel.gprsChannel.bind { [weak self] data in
            if let data = data {
                
                if !data.isEmpty {
                    if data.count > 1 {
                        let dialogMessage = UIAlertController(title: "Message", message: "Please, choose gprs channel.", preferredStyle: .actionSheet)
                        data.forEach { item in
                            let button = UIAlertAction(title: item.identity, style: .default, handler: { (action) in
                                self?.gprsChannelLabel.text = "\(item.systemId!)"
                            })
                            dialogMessage.addAction(button)
                        }
                        
                        self?.present(dialogMessage, animated: true, completion: nil)
                        
                    } else {
                        if let item = data.first {
                            self?.gprsChannelLabel.text = "\(item.systemId!)"
                        }
                        
                    }
                    
                } else {
                    self?.gprsChannelLabel.text = ""
                }
            }
        }
        
        self.viewModel.smsChannel.bind { [weak self] data in
            if let data = data {
                
                if !data.isEmpty {
                    if data.count > 1 {
                        let dialogMessage = UIAlertController(title: "Message", message: "Please, choose sms channel.", preferredStyle: .alert)
                        data.forEach { item in
                            let button = UIAlertAction(title: item.identity, style: .default, handler: { (action) -> Void in
                                self?.smsChannelLabel.text = "\(item.systemId!)"
                            })
                            dialogMessage.addAction(button)
                        }
                        
                        self?.present(dialogMessage, animated: true, completion: nil)
                        
                    } else {
                        if let item = data.first {
                            self?.smsChannelLabel.text = "\(item.systemId!)"
                        }
                        
                    }
                    
                } else {
                    self?.smsChannelLabel.text = ""
                }
            }
        }
        
        self.viewModel.data.bind { [weak self] data in
            if data != nil {
                self?.viewModel.systemId = data
            }
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, ddont do anything
            return
        }
        
        var shouldMoveViewUp = false
        
        let bottomOfSaveBarcodeBtn = saveBarcodeBtn.convert(saveBarcodeBtn.bounds, to: self.view).maxY
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        if bottomOfSaveBarcodeBtn > topOfKeyboard {
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
    
    func createOperatorsMenu() {
        var children: [UIAction] = []
        
        let operators = [
            "TURKCELL",
            "TELENOR",
            "TELE2",
            "TMOBILE",
            "DTAC",
            "VODAFONE",
            "AVEA"
        ]
        
        operators.forEach { oprtr in
            let item = UIAction(title: oprtr) { (action) in
                self.selectOperatorsBtn.setTitle(oprtr, for: .normal)
                self.viewModel.getGprsChannel(gprsChannel: oprtr)
                self.viewModel.getSmsChannel(smsChannel: oprtr)
                
            }
            children.append(item)
            
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: children)
        
        selectOperatorsBtn.menu = menu
        selectOperatorsBtn.showsMenuAsPrimaryAction = true
    }
    
    func createGsm() -> SimRegisterRequest {
        
        var simRegisterRequest: SimRegisterRequest = SimRegisterRequest()
        
        if gprsChannelLabel.text != "" {
            simRegisterRequest.gprsChannel = Int(gprsChannelLabel.text!)
        } else {
            simRegisterRequest.gprsChannel = 0
        }
        
        simRegisterRequest.identity = viewModel.fixPhoneNumber(phoneNumber: gsmLabel.text!)
        simRegisterRequest.pin = ""
        simRegisterRequest.pin2 = ""
        simRegisterRequest.puk = ""
        simRegisterRequest.puk2 = ""
        simRegisterRequest.provider = self.selectOperatorsBtn.titleLabel?.text
        simRegisterRequest.serialNumber = viewModel.fixPhoneNumber(phoneNumber: gsmLabel.text!)
        simRegisterRequest.state = self.didActiveLabel.text
        simRegisterRequest.smsChannel = Int(smsChannelLabel.text!)
        
        return simRegisterRequest
        
    }
    
}
