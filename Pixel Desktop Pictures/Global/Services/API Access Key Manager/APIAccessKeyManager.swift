//
//  APIKeyManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-07.
//

import Foundation
import Combine

/**
 A class responsible for managing the API key, its validation, and status updates.
 It interacts with UserDefaults for persistence and ensures the key's validity through API calls.
 */
@MainActor
@Observable
final class APIKeyManager {
    // MARK: - INNITIALIZER
    init() {
        apiKeyFailureSubscriber()
        networkConnectionStatusSubscriber()
    }
    
    // MARK: - ASSIGNED PROPERTIES
    
    // Managers/Services
    let defaults: UserDefaultsManager = .init()
    let networkManager: NetworkManager = .shared
    
    // Models
    let errorModel = APIKeyManagerErrorModel.self
    
    // Publishers
    private(set) var apiKeyValidationState: APIKeyValidityStates = .unknown { didSet { apiKeyValidationState$ = apiKeyValidationState } }
    @ObservationIgnored @Published private var apiKeyValidationState$: APIKeyValidityStates = .unknown
    var apiKeyValidationStatePublisher: AnyPublisher<APIKeyValidityStates, Never> {
        $apiKeyValidationState$.eraseToAnyPublisher()
    }
    
    
    @ObservationIgnored private(set) var apiKey: String?
    @ObservationIgnored private(set) var failedAPIKeyIndexes: Set<Int> = []
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    /// one api key grands 50 request per hour, so globally we can handle 50 x 10 (500) requests per hour for all users.
    let apiKeys: [String] = [
        "tYJmkmA0ZXLhmoPDiGEvIJxAHjI2V9d_BY2b2ueumR8",
        "7ej27jdK3xA-t6PhPiFYfPts0jUsv-WLQxa61g0gDrI",
        "LI1BeRqbbuTbwNTDNAscF_CG0HDTxSclXOJrqZuBX9Q",
        "WNifUUadNzXFz6khL7UmV4s5rBqG7KICTVUrIWcIp8k",
        "ZMy5hQsko63OaazqDYweHOgzL4_-LHOE0fsTrAEiOW0",
        "45bPf1xzjNsvfHOngiI3ZHEHbRhOUXS3TuqRvyX_c0U",
        "cd8awUo1YKKAqZmSM_7h7VRJTsmOClsikdXwY67mNEY",
        "nVV_ujxWJ5rBPjgoxBfszkQ3bvKheTbJdKX4rLEKyb8",
        "ExtS6bLb-Ou4gX-hBVEh7wupzZR9tAZwONR86ZWXzBo",
        "w9sxe_6HWTkUq6xZHRfZHLccukzf4_hN9iKedOA5RSE",
    ]
    
    // MARK: - SETTERS
    
    func setAPIKey(_ key: String?) {
        apiKey = key
    }
    
    func setAPIKeyValidationState(_ state: APIKeyValidityStates) {
        apiKeyValidationState = state
    }
    
    func insertFailedAPIKeyIndexOn(key: String) {
        guard let index: Int = apiKeys.getMatchedIndex(for: key) else { return }
        failedAPIKeyIndexes.insert(index)
    }
    
    func removeFailedAPIKeyIndexOn(key: String) {
        guard let index: Int = apiKeys.getMatchedIndex(for: key) else { return }
        failedAPIKeyIndexes.remove(index)
    }
    
    func removeAllFailedAPIKeyIndexes() {
        failedAPIKeyIndexes.removeAll()
    }
    
    func initializeAPIKeyManager() async {
        // First set the validation state to .unknown
        /// because we don't know what the exact state is when everything startup, so we begin with neural state called .unknown
        setAPIKeyValidationState(.unknown)
        
        // Then get the api key from user defaults.
        /// if the saved api key is nil, we take the first available api key from the api keys array and proceed with the validation.
        let apiKey: String? = getAPIKeyFromUserDefaults() ?? apiKeys.first
        
        guard let apiKey else { /// This guard statement must not ever get called for any reason.
            Utilities.quitApp()
            return
        }
        
        await validateAPIKey(apiKey)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func apiKeyFailureSubscriber() {
        let failureStates: [APIKeyValidityStates] = [.invalid, .rateLimited, .allRateLimited]
        
        $apiKeyValidationState$
            .dropFirst()
            .removeDuplicates()
            .compactMap { failureStates.contains($0) ? $0 : nil } // Omit non-failure states as we're handling errors here.
            .sink { [weak self] state in
                guard let self else { return }
                
                Logger.log("❔: apiKeyValidationState: \(state.rawValue)")
                Logger.log(errorModel.failureDetected.localizedDescription)
                
                switch state {
                case .invalid, .rateLimited: invalid_RateLimited(state)
                case .failed: failed()
                case .allRateLimited: allRateLimited()
                    
                default: // Default case will never get executed
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func networkConnectionStatusSubscriber() {
        networkManager.$connectionStatus$
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] state in
                guard let self, apiKeyValidationState == .failed, state == .connected else { return }
                
                Logger.log("✅: Revalidating API key on network connection.")
                
                Task { [weak self] in
                    await self?.validateNextAPIKey()
                }
            }
            .store(in: &cancellables)
        
    }
}

// MARK: - EXTENSIONS
private extension APIKeyManager {
    private func invalid_RateLimited(_ state: APIKeyValidityStates) {
        switch state {
        case .invalid:
            Logger.log(errorModel.invalidAPIKey.localizedDescription)
            
        case .rateLimited:
            Logger.log(errorModel.rateLimitedAPIKey.localizedDescription)
            
        default:
            break
        }
        
        /// Invalid means the current api key is not working
        /// It's time to validate the next available api key from the api keys array.
        
        /// If there's no next available api key means we are rate limited on all the keys we have.
        guard let nextAPIKey: String = getNextAvailableAPIKey() else {
            setAPIKeyValidationState(.allRateLimited)
            return
        }
        
        /// If there's a next available api key, we validate
        Task { [weak self] in await self?.validateAPIKey(nextAPIKey) }
    }
    
    private func failed() {
        Task {
            await ErrorPopupViewModel.shared
                .addError(GlobalErrorPopup.connectionTimeout)
        }
        
        Logger.log(errorModel.timeout.localizedDescription)
    }
    
    private func allRateLimited() {
        Logger.log(errorModel.allRateLimited.localizedDescription)
        
        /// Now it's time to clear all the `failedAPIKeyIndexes` and iterate again to find a valid api key.
        removeAllFailedAPIKeyIndexes()
        
        /// Then get an api key from the api keys array as `failedAPIKeyIndexes` are empty.
        guard let nextAPIKey: String = getNextAvailableAPIKey() else { return }
        
        Task { [weak self] in
            await self?.validateAPIKey(nextAPIKey)
        }
        
        Logger.log("⚠️: Validating an API key after the all rate limited error.")
    }
}
