//
//  MapVM_Validations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-08.
//

import Foundation

extension MainTabViewModel {
    func disableSetDesktopPictureButton() -> Bool {
        let condition1: Bool = {
            switch apiKeyManager.apiKeyValidationState {
            case .unknown, .noInternet, .validating, .invalid, .failed, .rateLimited:
                return true
                
            case .connected:
                return false
            }
        }()
        let condition2: Bool = centerItem == .progressView
        let condition3: Bool = currentImage != nil
        
        return condition1 && condition2 && condition3
    }
    
    func disableHitTestingOnImageContainer() -> Bool {
        let condition1: Bool = centerItem == .progressView
        
        return condition1
    }
}
