//
//  AlertsManager.swift
//  DailyDesktopPicture
//
//  Created by Kavinda Dilshan on 2024-12-19.
//

import SwiftUI

// MARK: MODELS

// MARK: - Alerts Model
struct AlertsModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let message: String?
    let primaryButton: Alert.Button
    let secondaryButton: Alert.Button?
}

// MARK: Alerts Manager Class
@MainActor
@Observable final class AlertsManager {
    // MARK: - PROPERTIES
    static let shared: AlertsManager = .init()
    var alertItem: AlertsModel? {
        didSet {
            // Triggers only on alert dismiss
            guard alertItem == nil else { return }
            triggerAvailableAlertInQueue(nil)
        }
    }
    private var alertsQueue: [AlertsModel] = []
    
    // MARK: - INITIALIZER
    private init() { }
    
    // MARK: FUNCTIONS
    
    // MARK: - Set Alert
    func setAlert(_ item: AlertsModel) {
        addAlertToQueue(item)
    }
    
    // MARK: - Add Alert To Queue
    private func addAlertToQueue(_ item: AlertsModel) {
        guard !alertsQueue.contains(where: { $0.id == item.id }) else { return }
        alertsQueue.append(item)
        triggerAvailableAlertInQueue(item)
    }
    
    // MARK: - Trigger Available Alert In Queue
    private func triggerAvailableAlertInQueue(_ item: AlertsModel?) {
        guard item == nil else {
            if alertsQueue.count == 1 {
                alertItem = alertsQueue.first
            }
            return
        }
        
        alertsQueue.removeFirst()
        guard let nextAlert = alertsQueue.first else { return }
        
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            alertItem = nextAlert
        }
    }
}

// MARK: EXTENSIONS
extension View {
    // MARK: - Alert View Modifier
    func alertViewModifier() -> some View {
        let alertManager: AlertsManager = .shared
        return self
            .alert(item: alertManager.binding(\.alertItem)) { item in
                let title: Text = .init(item.title)
                let message: Text? = item.message.map(Text.init)
                
                if let secondaryButton: Alert.Button = item.secondaryButton {
                    return .init(
                        title: title,
                        message: message,
                        primaryButton: item.primaryButton,
                        secondaryButton: secondaryButton
                    )
                } else {
                    return .init(
                        title: title,
                        message: message,
                        dismissButton: item.primaryButton
                    )
                }
            }
    }
}
