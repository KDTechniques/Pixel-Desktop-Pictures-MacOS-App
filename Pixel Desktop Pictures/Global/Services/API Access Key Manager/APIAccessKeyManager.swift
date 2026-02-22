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
        networkConnectionSubscriber()
    }
    
    // MARK: - ASSIGNED PROPERTIES
    
    // Managers/Services
    let defaults: UserDefaultsManager = .init()
    let networkManager: NetworkManager = .shared
    
    // Models
    let errorModel = APIKeyManagerError.self
    
    // Publishers
    private(set) var apiKeyValidationState: APIKeyValidityStates?
    
    @ObservationIgnored private(set) var apiKey: String?
    @ObservationIgnored private(set) var failedAPIKeyIndexes: Set<Int> = []
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    /// one api key grands 50 request per hour, so globally we can handle 50 x 10 (500) requests per hour for all users.
    let apiKeys: [String] = [ // invalid key for testing purposes: 2do6EHZxsHAQ_Aprpob3hGXHaBPDGHYscSt9hPlxuIQ
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
    
    func setAPIKeyValidationState(_ state: APIKeyValidityStates?) {
        apiKeyValidationState = state
    }
    
    func insertFailedAPIKeyIndex(_ index: Int) {
        failedAPIKeyIndexes.insert(index)
    }
    
    func removeFailedAPIKeyIndex(_ index: Int) {
        failedAPIKeyIndexes.remove(index)
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func initializeAPIKeyManager() async {
        // First get the api key from user defaults.
        /// if the saved api key is nil, we take the first available api key from the api keys array and proceed with the validation.
        let apiKey: String? = getAPIKeyFromUserDefaults() ?? apiKeys.first
        
        guard let apiKey else { return }
        
        // Even if the key is not nil, it might be invalid, rate limited or something else at the moment.
        /// Yet we still assign the value to the api key and set the validation state to `.unknown`.
        /// while `.unknown` state is being handled by the front end for better user experience we perform the validation in the background to make sure the api key is valid.
        /// Ex: even if the retrieved key is invalid we can show the usual UI to the user, until we are done processing the validation.
        /// If user tries to reload the next image while the invalid api is there, they will see a circular progress or something like that until we finish processing the api key validation.
        setAPIKey(apiKey)
        setAPIKeyValidationState(.unknown)
        await handleAPIKeyValidation(apiKey)
    }
    
    /// Retrieves the current API key.
    ///
    /// - Returns: The stored API key or nil if not found.
    /// - Fetches key from UserDefaults if not already in memory.
    func getAPIKey() async -> String? {
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
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func networkConnectionSubscriber() {
        networkManager.$connectionStatus$
            .removeDuplicates()
            .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
            .sink { [weak self] connection in
                guard
                    let self,
                    connection == .connected,
                    apiKeyValidationState == .noInternet,
                    apiKeyValidationState != .validating else { return }
                
                Task { [weak self] in
                    await self?.initializeAPIKeyManager()
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func handleAPIKeyValidation(_ key: String) async {
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
            /// finally set the validity state to `.connected`
            saveAPIKeyToUserDefaults(key)
            setAPIKey(key)
            setAPIKeyValidationState(.connected)
            print("✅: Successful API key validation.")
        } catch let error {
            // In case of api key invalidation we have to figure out a way to iterate through other available api keys from the api keys array and find a valid key.
            /// error can be due to not having connected to the internet, rate limited or invalid, so we need to handle it properly while maintaining better UX.
            let validationState: APIKeyValidityStates = handleURLError(error)
            
            /// user might see a specific UI only when the app is  not connected to the internet or api key validation is failed.
            /// that means for some reason if all api keys are rate limited, invalid or failed we have to show a specific message to the user asking to try again later.
            validationState == .noInternet ? setAPIKeyValidationState(validationState) : ()
            Logger.log(errorModel.apiKeyValidationFailed(error).localizedDescription)
            
            await onAPIKeyValidationFailure(key)
        }
    }
    
    private func onAPIKeyValidationFailure(_ key: String) async {
        switch apiKeyValidationState {
        case .invalid, .failed, .rateLimited:
            guard let failedAPIKeyIndex: Int = apiKeys.getMatchedIndex(for: key) else { return }
            
            insertFailedAPIKeyIndex(failedAPIKeyIndex)
            
            guard failedAPIKeyIndexes.count != apiKeys.count else {
                setAPIKeyValidationState(.rateLimited)
                return
            }
            
            // Start coding here.....
            
            
        default:
            break
        }
    }
    
    private func handleURLError(_ error: Error) -> APIKeyValidityStates {
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
