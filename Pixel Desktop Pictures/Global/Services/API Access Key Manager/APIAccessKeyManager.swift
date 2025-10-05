//
//  APIAccessKeyManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-07.
//

import Foundation
import Combine

/**
 A class responsible for managing the API access key, its validation, and status updates.
 It interacts with UserDefaults for persistence and ensures the access key's validity through API calls.
 */
@MainActor
@Observable
final class APIAccessKeyManager {
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .shared
    let networkManager: NetworkManager = .shared
    @ObservationIgnored private var apiAccessKey: String?
    @ObservationIgnored private(set) var apiAccessKeyValidationState: APIAccessKeyValidityStates?
    let errorModel: APIAccessKeyManagerError.Type = APIAccessKeyManagerError.self
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INNITIALIZER
    init() {
        networkConnectionSubscriber()
        Task { await initializeAPIAccessKeyManager() }
    }
    
    
    // MARK: - SETTERS
    
    func setAPIAccessKey(_ value: String?) {
        apiAccessKey = value
    }
    
    func setAPIAccessKeyValidationState(_ value: APIAccessKeyValidityStates?) {
        apiAccessKeyValidationState = value
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    /// Retrieves the current API access key.
    ///
    /// - Returns: The stored API access key or nil if not found.
    /// - Fetches key from UserDefaults if not already in memory.
    func getAPIAccessKey() async -> String? {
        guard let apiAccessKey else {
            guard let savedAPIAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                return nil
            }
            
            apiAccessKey = savedAPIAccessKey
            return savedAPIAccessKey
        }
        
        Logger.log("✅: returned API access key.")
        return apiAccessKey
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func networkConnectionSubscriber() {
        networkManager.$connectionStatus$
            .removeDuplicates()
            .sink { [weak self] connection in
                guard let self,
                connection == .connected && apiAccessKeyValidationState == .noInternet else { return }
                
                Task { [weak self] in
                    await self?.initializeAPIAccessKeyManager()
                }
            }
            .store(in: &cancellables)
        
    }
    
    func initializeAPIAccessKeyManager() async {
        guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() ?? apiAccessKeys.first else { return }
        
        await apiAccessKeyValidation(apiAccessKey)
    }
    
    private func apiAccessKeyValidation(_ key: String) async {
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: key)
        
        do {
            try await imageAPIService.validateAPIAccessKey()
            
            // Handle Successful API Access Key Validation
            await saveAPIAccessKeyToUserDefaults(key)
            setAPIAccessKey(key)
            setAPIAccessKeyValidationState(.connected)
            print("✅: Successful API access key validation.")
        } catch let error {
            let validationState: APIAccessKeyValidityStates = handleURLError(error)
            validationState != .rateLimited ? setAPIAccessKeyValidationState(validationState) : ()
            Logger.log(errorModel.apiAccessKeyValidationFailed(error).localizedDescription)
            
            await onAPIAccessKeyValidationFailure(key)
        }
    }
    
    private func onAPIAccessKeyValidationFailure(_ key: String) async {
        switch apiAccessKeyValidationState {
        case .invalid, .failed, .rateLimited:
            guard let currentIndex: Int = apiAccessKeys.getMatchedIndex(for: key) else { return }
            let nextIndex: Int = apiAccessKeys.getNextIndex(currentIndex)
            
            if nextIndex != currentIndex {
                let nextAPIAccessKey: String = apiAccessKeys[nextIndex]
                await apiAccessKeyValidation(nextAPIAccessKey)
            } else {
                setAPIAccessKeyValidationState(.rateLimited)
            }
        default:
            ()
        }
    }
    
    private func handleURLError(_ error: Error) -> APIAccessKeyValidityStates {
        guard let urlError: URLError = error as? URLError else { return .failed }
        
        switch urlError.code {
        case .notConnectedToInternet:
            return .noInternet
            
        case .clientCertificateRejected:
            return .rateLimited
            
        case .userAuthenticationRequired:
            return .invalid
            
        default:
            return .failed
        }
    }
}
