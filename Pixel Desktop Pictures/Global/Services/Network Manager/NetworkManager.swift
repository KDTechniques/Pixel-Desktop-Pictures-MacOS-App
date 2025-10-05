//
//  NetworkManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import Foundation
import Network
import Combine

/**
 A main-actor-bound, observable class responsible for monitoring and managing the device's network connection status.
 It provides real-time updates on the internet connection status and handles changes in connectivity.
 This class leverages `NWPathMonitor` to monitor network paths and uses Combine to publish connection status updates.
 */
@MainActor
@Observable
final class NetworkManager {
    // MARK: - ASSIGNED PROPERTIES
    static let shared: NetworkManager = .init()
    private let monitor = NWPathMonitor()
    private let networkManagerQueue = DispatchQueue(label: "com.kdtechniques.Pixel-Desktop-Pictures.NetworkManager.networkManagerQueue")
    private(set) var connectionStatus: InternetConnectionStatus = .noConnection {
        didSet { connectionStatus$ = connectionStatus }
    }
    @ObservationIgnored @Published private(set) var connectionStatus$: InternetConnectionStatus = .noConnection
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    private init() {
        connectionStatusSubscriber()
        startNetworkMonitor()
        Logger.log("✅: `Network Manager` has been initialized")
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Subscribes to changes in the `connectionStatus$` property and handles updates accordingly.
    private func connectionStatusSubscriber() {
        $connectionStatus$
            .removeDuplicates()
            .sink { [weak self] status in
                guard let self else { return }
                
                switch status {
                case .connected:
                    handleConnectedStatus()
                case .noConnection:
                    handleNoConnectionStatus()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Starts monitoring the network path for changes in connectivity.
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
    
    /// Handles actions when the device is connected to a network.
    private func handleConnectedStatus() {
        Logger.log("✅🛜: Connected to a Network.")
    }
    
    /// Handles actions when the device loses network connectivity.
    private func handleNoConnectionStatus() {
        Logger.log("❌🛜: No Network Connection.")
    }
}
