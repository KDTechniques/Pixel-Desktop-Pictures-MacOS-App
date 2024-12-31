//
//  AlertsManager.swift
//  DailyDesktopPicture
//
//  Created by Kavinda Dilshan on 2024-12-19.
//

import SwiftUI

// MARK: Alerts Manager Class
@MainActor
@Observable final class AlertsManager {
    // MARK: - PROPERTIES
    static let shared: AlertsManager = .init()
    var isPresented: Bool = false
    var error: AppError?
}

enum AppError: LocalizedError {
    case sampleError
    
    var errorDescription: String? {
        switch self {
        case .sampleError:
            return "This is the title"
        }
    }
}

// MARK: EXTENSIONS
extension View {
    // MARK: - Alert View Modifier
    func alertViewModifier() -> some View {
        let alertManager: AlertsManager = .shared
        return self
            .alert(isPresented: alertManager.binding(\.isPresented), error: alertManager.error) { error in
                Text(error.errorDescription ?? "No Title")
            } message: { error in
                
            }
    }
}

