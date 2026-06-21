//
//  GlobalErrorPopup.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-19.
//

import Foundation

enum GlobalErrorPopup: ErrorPopupProtocol {
    case connectionTimeout
    
    var title: String {
        switch self {
        case .connectionTimeout:
            return "Something went wrong.\nPlease check your internet connection, and try again later."
        }
    }
}
