//
//  MapVM_Validations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-08.
//

import Foundation

extension MainTabViewModel {
    func disableOnFirstLaunch() -> Bool {
        let condition1: Bool = Utilities.isImageCacheOrDiskEmpty()
        let condition2: Bool = apiKeyManager.apiKeyValidationState == .unknown
        
        return condition1 && condition2
    }
    
    func disableHitTestingOnImageContainer() -> Bool {
        let condition1: Bool = centerItem == .progressView
        
        return condition1
    }
}
