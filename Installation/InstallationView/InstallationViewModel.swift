//
//  InstallationViewModel.swift
//  Installation
//
//  Created by Zehra on 13.08.2022.
//

import Foundation

final class InstallationViewModel {
    var session: Session?
    
    var brands: ObservableObject<[BrandResponse]?> = ObservableObject(nil)
    var models: ObservableObject<[ModelResponse]?> = ObservableObject(nil)
    
    func getBrands() {
        
        var brandsList: [BrandResponse] = []
        
        if let session = session {
            let brandRequest = BrandRequest(identity: "", name: "")
            NetworkManager.shared.getBrands(session: session, brandRequest: brandRequest) { [weak self] result in
                switch result {
                case .success(let brandRequest):
                    brandRequest.forEach { brand in
                        brandsList.append(brand)
                    }
                    self?.brands.value = brandsList
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getModels(brand: Int) {
        
        var modelsList: [ModelResponse] = []
        
        if let session = session {
            let modelRequest = ModelRequest(brand: brand)
            NetworkManager.shared.getModels(session: session, modelRequest: modelRequest) { [weak self] result in
                switch result {
                case .success(let modelRequest):
                    modelRequest.forEach { model in
                        modelsList.append(model)
                    }
                    self?.models.value = modelsList
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
