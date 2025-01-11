//
//  SwiftDataManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum SwiftDataManagerErrorModel: LocalizedError {
    case modelContainerInitializationFailed(_ error: Error)
    case contextSaveFailed(_ error: Error)
    case eraseAllDataFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .modelContainerInitializationFailed(let error):
            return "Error: Failed to initialize model container. \(error.localizedDescription)"
        case .contextSaveFailed(let error):
            return "Error: Failed to save context to container. \(error.localizedDescription)"
        case .eraseAllDataFailed(let error):
            return "Error: Failed to erase all data from recent image url model container. \(error.localizedDescription)"
        }
    }
}
