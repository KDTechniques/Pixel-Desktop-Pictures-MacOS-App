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
    // MARK: - ASSIGNED PROPERTIES
    static let shared: NetworkManager = .init()
    private let monitor = NWPathMonitor()
    private let networkManagerQueue = DispatchQueue(label: "com.kdtechniques.Pixel-Desktop-Pictures.NetworkManager.networkManagerQueue")
    private(set) var connectionStatus: InternetConnectionStatusModel = .noConnection {
        didSet {
            connectionStatus$ = connectionStatus
            guard oldValue != connectionStatus else { return }
            
            switch connectionStatus {
            case .connected:
                handleConnectedStatus()
            case .noConnection:
                handleNoConnectionStatus()
            }
        }
    }
    @ObservationIgnored @Published private(set) var connectionStatus$: InternetConnectionStatusModel = .noConnection
    
    // MARK: - INITIALIZER
    private init() {
        startNetworkMonitor()
        print("✅: `Network Manager` has been initialized successfully.")
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
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
    
    private func handleConnectedStatus() {
        print("✅🛜: Connected to a Network.")
    }
    
    private func handleNoConnectionStatus() {
        print("❌🛜: No Network Connection.")
    }
}
