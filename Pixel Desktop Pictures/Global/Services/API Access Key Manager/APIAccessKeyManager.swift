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
    /// invalid key for testing purposes: 2do6EHZxsHAQ_Aprpob3hGXHaBPDGHYscSt9hPlxuIQ
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
    
    // MARK: - PUBLIC FUNCTIONS
    
    func initializeAPIKeyManager() async {
        setAPIKeyValidationState(.unknown)
        
        // First get the api key from user defaults.
        /// if the saved api key is nil, we take the first available api key from the api keys array and proceed with the validation.
        let apiKey: String? = getAPIKeyFromUserDefaults() ?? apiKeys.first
        
        guard let apiKey else { return } // this guard statement must not ever get called for any reason.
        
        // Validate the API key and set it as `the` API key
        await validateAPIKey(apiKey)
        setAPIKey(apiKey)
    }
    
    /// Retrieves the current API key.
    ///
    /// - Returns: The stored API key or nil if not found.
    /// - Fetches key from UserDefaults if not already in memory.
    func getAPIKey() -> String? {
        guard let apiKey else {
            guard let savedAPIKey: String = getAPIKeyFromUserDefaults() else {
                return nil
            }
            
            apiKey = savedAPIKey
            return savedAPIKey
        }
        
        Logger.log("✅: Returned API key.")
        return apiKey
    }
    
    func validateAPIKey(_ key: String) async {
        // We don't try to validate an api key when there's one already validating in the background
        guard apiKeyValidationState != .validating else { return }
        
        // Start the API key validation process
        setAPIKeyValidationState(.validating)
        
        // To validate the api key we must create an instance of Unsplash image api service by passing the given api key.
        let imageAPIService: UnsplashImageAPIService = .init(apiKey: key)
        
        do {
            // if the api key validation is successful, next line get executed otherwise it throws an error
            try await imageAPIService.validateAPIKey()
            
            // Handle Successful API  Key Validation
            /// here we save the valid api key to user defaults
            /// then assign the valid key to the api key property
            /// finally set the validity state to `.valid`
            saveAPIKeyToUserDefaults(key)
            setAPIKey(key)
            setAPIKeyValidationState(.valid)
            print("✅: Successful API key validation.")
        } catch (let error) {
            // In case of api key invalidation we have to figure out a way to iterate through other available api keys from the api keys array and find a valid key.
            /// error can be due to not having connected to the internet, rate limited or invalid, so we need to handle it properly while maintaining better UX.
            let validationState: APIKeyValidityStates = Utilities.APIKeyValidityStateOnURLError(error)
            setAPIKeyValidationState(validationState)
            insertFailedAPIKeyIndexOn(key: key)
            Logger.log(errorModel.apiKeyValidationFailed(error).localizedDescription)
        }
    }
    
    func validateCurrentAPIKey() async {
        guard let currentAPIKey: String = getAPIKey() else { return }
        await validateAPIKey(currentAPIKey)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func apiKeyFailureSubscriber() {
        let failureStates: [APIKeyValidityStates] = [.invalid, .rateLimited]
        
        $apiKeyValidationState$
            .dropFirst()
            .removeDuplicates()
            .compactMap { failureStates.contains($0) ? $0 : nil } // Omit non-failure states as we're handling errors here.
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .invalid, .rateLimited:
                    /// invalid means the current api key is not working
                    /// It's time to validate the next available api key from the api keys array.
                    
                    /// if there's no next available api key means we are rate limited on all the keys we have.
                    guard let nextAPIKey: String = getNextAvailableAPIKey() else {
                        setAPIKeyValidationState(.allRateLimited)
                        Logger.log("⚠️: All Rate Limited!")
                        return
                    }
                    
                    /// if there's a next available api key, we validate
                    Task { [weak self] in await self?.validateAPIKey(nextAPIKey) }
                    return
                    
                case .failed:
                    Task { await ErrorPopupViewModel.shared.addError(GlobalErrorPopup.connectionTimeout) }
                    return
                    
                default: // Default case will never get executed
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func getNextAvailableAPIKey() -> String? {
        let limit = apiKeys.count
        
        // Filter the range to find numbers NOT in the set
        let availableIndexes: [Int] = (0..<limit).filter { !failedAPIKeyIndexes.contains($0) }
        
        // Safely grab a random element from the remaining choices
        guard let randomIndex: Int = availableIndexes.randomElement() else {
            // If available indexes are empty that means all the api keys have been failed.
            /// that means we have encountered the rate limited issue.
            return nil
        }
        
        return apiKeys[randomIndex]
    }
    
    private func networkConnectionStatusSubscriber() {
        networkManager.$connectionStatus$
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] state in
                guard let self, apiKeyValidationState == .failed, state == .connected else { return }
                
                Task { [weak self] in
                    await self?.validateCurrentAPIKey()
                }
            }
            .store(in: &cancellables)
        
    }
}
