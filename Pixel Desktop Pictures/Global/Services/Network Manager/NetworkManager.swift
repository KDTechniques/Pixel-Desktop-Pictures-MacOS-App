//
//  NetworkManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import Foundation
import Network

@MainActor
@Observable
final class NetworkManager {
    // MARK: - PROPERTIES
    private let monitor = NWPathMonitor()
    private let networkManagerQueue = DispatchQueue(label: "com.kdtechniques.Pixel-Desktop-Pictures.NetworkManager.networkManagerQueue")
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
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Initialize Network Manager
    func initializeNetworkManager() {
        startNetworkMonitor()
        print("Network Manager Initialized!")
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - startNetworkMonitor
    private func startNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            if path.status == .satisfied {
                Task { @MainActor in
                    if self.connectionStatus != .connected {
                        self.connectionStatus = .connected
                    }
                }
            } else {
                Task { @MainActor in
                    if self.connectionStatus != .noConnection {
                        self.connectionStatus = .noConnection
                    }
                }
            }
        }
        monitor.start(queue: networkManagerQueue)
    }
    
    // MARK: - handleConnectedStatus
    private func handleConnectedStatus() {
        print("Connected to a Network. 🛜")
    }
    
    // MARK: - handleNoConnectionStatus
    private func handleNoConnectionStatus() {
        print("No Network Connection. 😕")
    }
}
