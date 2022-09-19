//
//  NewInstallationViewModel.swift
//  Installation
//
//  Created by Zehra on 1.08.2022.
//

import Foundation

protocol NewInstallationViewModelControlProtocol: AnyObject {
    func controlImei()
}

protocol NewInstallationViewModelGsmProtocol: AnyObject {
    func getGsm() -> String?
}

final class NewInstallationViewModel {
    
    var session: Session?
    var systemId: Int?
    var gsmAssignRequest: GsmAssignRequest?
    
    var QRCode: String?
    var didControlImei: Bool = false
    var didControlGsm: Bool = false
    
    weak var controlDelegate: NewInstallationViewModelControlProtocol?
    weak var gsmDelegate: NewInstallationViewModelGsmProtocol?
    
    var imei: ObservableObject<ImeiResponse?> = ObservableObject(nil)
    var gprsChannel: ObservableObject<[GprsResponse]?> = ObservableObject(nil)
    var smsChannel: ObservableObject<[SmsResponse]?> = ObservableObject(nil)
    
    var data: ObservableObject<Int?> = ObservableObject(nil)
    var error: ObservableObject<String?> = ObservableObject(nil)
    
    func controlImei(serial: String) {
        if let session = session {
            NetworkManager.shared.findBySerial(session: session, serial: serial) { [weak self] result in
                switch result {
                case .success(let imeiResponse):
                    if imeiResponse.clientIdentity == nil {
                        NetworkManager.shared.imeiControlError(session: session, serial: serial) { [weak self] result in
                            switch result {
                            case .success:
                                self?.error.value = "The device can't registered, check imei number."
//                                if Locale.current.languageCode == "tr" {
//                                    self?.error.value = errorResponse.tr_TR
//                                } else {
//                                    self?.error.value = errorResponse.en_US
//                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        self?.error.value = "Imei control is successful."
                        self?.controlDelegate?.controlImei()
                        
                        /*if imeiResponse.assetId == 0 {
                            self?.gsmAssignRequest?.deviceIdentity = imeiResponse.clientIdentity
                            if imeiResponse.gsmAccount != nil && imeiResponse.gsmAccount != "" {
                                self?.gsmAssignRequest?.oldGsmIdentity = imeiResponse.gsmAccount
                            } /*else if {
//
                            }*/
                            let gsm = self?.gsmDelegate?.getGsm()
                            self?.gsmAssignRequest?.newGsmIdentity = self?.fixPhoneNumber(phoneNumber: gsm!)
                        }*/
                    }
                case .failure(let error):
                    if serial == "" {
                        self?.error.value = "Please, enter the imei."
                    } else {
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
    }
    
    func controlGsm(query: String) {
        if let session = session {
            NetworkManager.shared.getAllGsm(session: session, query: query) { [weak self] result in
                switch result {
                case .success(let gsmResponse):
                    print(gsmResponse)
                    self?.didControlGsm = true
                case .failure(let error):
                    if query == "" {
                        self?.error.value = "Please, enter the gsm."
                    } else {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getGprsChannel(gprsChannel: String) {
        var gprsList: [GprsResponse] = []
        
        if let session = session {
            NetworkManager.shared.getGprs(session: session) { [weak self] result in
                switch result {
                case .success(let gprsResponse):
                    gprsResponse.forEach { gprs in
                        
                        let separator = CharacterSet(charactersIn: "_")
                        let separateResult = gprs.identity?.components(separatedBy: separator)
                        
                        if let separateResult = separateResult {
                            let gprsIdentity = separateResult[0]
                            if gprsIdentity == gprsChannel {
                                gprsList.append(gprs)
                                
                            }
                        }
                    }
                    
                    self?.gprsChannel.value = gprsList
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getSmsChannel(smsChannel: String) {
        var smsList: [SmsResponse] = []
        
        if let session = session {
            NetworkManager.shared.getSms(session: session) { [weak self] result in
                switch result {
                case .success(let smsResponse):
                    smsResponse.forEach { sms in
                        
                        let separator = CharacterSet(charactersIn: "_")
                        let separateResult = sms.identity?.components(separatedBy: separator)
                        
                        if let separateResult = separateResult {
                            let smsIdentity = separateResult[0]
                            if smsIdentity == smsChannel {
                                smsList.append(sms)
                            }
                        }
                    }
                    
                    self?.smsChannel.value = smsList
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    func createGsm(simRegisterRequest: SimRegisterRequest) {
        if let session = session {
            NetworkManager.shared.createGsm(session: session, simRegisterRequest: simRegisterRequest) { [weak self] result in
                switch result {
                case .success(let gsmCreateResponse):
                    if gsmCreateResponse.systemId == nil {
                        NetworkManager.shared.saveSimCardError(session: session, simRegisterRequest: simRegisterRequest) { [weak self] result in
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
                        self?.data.value = gsmCreateResponse.systemId
                        self?.error.value = "Gsm is created. systemID: \(gsmCreateResponse.systemId!)"
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fixPhoneNumber(phoneNumber: String) -> String {
        
        if phoneNumber.contains("+") {
            return phoneNumber
        }
        
        var phoneNumberReplacedOccurences = phoneNumber.replacingOccurrences(of: "", with: "").replacingOccurrences(of: "\\(", with: "").replacingOccurrences(of: "-", with: "").trimmingCharacters(in: .whitespaces)
        
        if phoneNumberReplacedOccurences.starts(with: "+90") || phoneNumberReplacedOccurences.starts(with: "00") {
            
        } else if  phoneNumberReplacedOccurences.starts(with: "0") {
            phoneNumberReplacedOccurences = "+9" + phoneNumberReplacedOccurences
        } else if phoneNumberReplacedOccurences.starts(with: "90") {
            phoneNumberReplacedOccurences = "+" + phoneNumberReplacedOccurences
        } else {
            phoneNumberReplacedOccurences = "+90" + phoneNumberReplacedOccurences
        }
        
        return phoneNumberReplacedOccurences
    }
    
}
