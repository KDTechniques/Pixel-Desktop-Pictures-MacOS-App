//
//  MockNetworkManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation
import Network

@MainActor
@Observable
final class MockNetworkManager: NetworkManagerProtocol {
    // MARK: - MOCK PROPERTIES
    private(set) var connectionStatus: InternetConnectionStatusModel = .noConnection {
        didSet {
            guard oldValue != connectionStatus else { return }
            
            switch connectionStatus {
            case .connected:
                handleConnectedStatus()
            case .noConnection:
                handleNoConnectionStatus()
            }
        }
    }
    
    // MARK: MOCK FUNCTIONS
    
    // MARK: - Simulate Network Connection Change
    func simulateNetworkChange(to status: InternetConnectionStatusModel) {
        connectionStatus = status
    }
    
    // MARK: - Handle Connected Status
    private func handleConnectedStatus() {
        print("Mock: Connected to a Network. 🛜")
    }
    
    // MARK: - Handle No Connection Status
    private func handleNoConnectionStatus() {
        print("Mock: No Network Connection. 😕")
    }
}
