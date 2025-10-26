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
    // MARK: - INNITIALIZER
    init() {
        networkConnectionSubscriber()
    }
    
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .init()
    let networkManager: NetworkManager = .shared
    @ObservationIgnored private(set) var apiAccessKey: String?
    private(set) var apiAccessKeyValidationState: APIAccessKeyValidityStates?
    let errorModel = APIAccessKeyManagerError.self
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    @ObservationIgnored private(set) var initialAPIKeyIndex: Int?
    
    
    // MARK: - SETTERS
    
    func setAPIAccessKey(_ value: String?) {
        apiAccessKey = value
    }
    
    func setAPIAccessKeyValidationState(_ value: APIAccessKeyValidityStates?) {
        apiAccessKeyValidationState = value
    }
    
    func setInitialAPIKeyIndex(_ value: Int) {
        initialAPIKeyIndex = value
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func initializeAPIAccessKeyManager() async {
        // First get the api key from user defaults, and it may be nil.
        let savedAPIKey: String? = getAPIAccessKeyFromUserDefaults()
        
        // Even if the key is not nil, it might be invalid or rate limited at the moment.
        if savedAPIKey != nil {
            // Yet we still assign the value to the api access key and set the validation state to `.unknown`.
            /// while `.unknown` state is being handled by the front end for better user experience we perform the validation in the background to make sure the api key is valid.
            /// Ex: even if the retrieved key is invalid we can show the usual UI to the user, until we are done processing the validation.
            /// If user tries to reload the next image while the invalid api is there, they will see a circular progress or something like that until we finish processing the api key validation.
            setAPIAccessKey(savedAPIKey)
            setAPIAccessKeyValidationState(.unknown)
        }
        
        // if the saved api key is nil we take the first available api key from the api keys array and proceed with the validation.
        guard let apiAccessKey: String = savedAPIKey ?? apiAccessKeys.first else { return }
        await apiAccessKeyValidation(apiAccessKey)
    }
    
    /// Retrieves the current API access key.
    ///
    /// - Returns: The stored API access key or nil if not found.
    /// - Fetches key from UserDefaults if not already in memory.
    func getAPIAccessKey() async -> String? {
        guard let apiAccessKey else {
            guard let savedAPIAccessKey: String = getAPIAccessKeyFromUserDefaults() else {
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
            .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
            .sink { [weak self] connection in
                guard let self,
                      connection == .connected && apiAccessKeyValidationState == .noInternet else { return }
                
                Task { [weak self] in
                    await self?.initializeAPIAccessKeyManager()
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func apiAccessKeyValidation(_ key: String) async {
        // To validate the api key we must create an instance of Unsplash image api service by passing the given api key.
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: key)
        
        do {
            // if the api key validation is successful next line get executed otherwise it throws an error
            try await imageAPIService.validateAPIAccessKey()
            
            // Handle Successful API Access Key Validation
            /// here we save the valid api key to user defaults
            /// then assign the valid key to the api access key property
            /// finally set the validity state to `.connected`
            saveAPIAccessKeyToUserDefaults(key)
            setAPIAccessKey(key)
            setAPIAccessKeyValidationState(.connected)
            print("✅: Successful API access key validation.")
        } catch let error {
            // In case of api key invalidation we have to figure out a way to iterate through other available api keys from the api keys array and find a valid key.
            /// error can be due to not having access to the internet, so we need to handle it properly while maintaining better UX.
            let validationState: APIAccessKeyValidityStates = handleURLError(error)
            
            /// user might see a specific UI only when the app is  not connected to the internet or api key validation is failed.
            /// that means for some reason if all api keys are rate limited, invalid or failed we have to show a specific message to the user asking to try again later or to wait for the next update.
            validationState == .noInternet ? setAPIAccessKeyValidationState(validationState) : ()
            Logger.log(errorModel.apiAccessKeyValidationFailed(error).localizedDescription)
            
            await onAPIAccessKeyValidationFailure(key)
        }
    }
    
    private func onAPIAccessKeyValidationFailure(_ key: String) async {
        switch apiAccessKeyValidationState {
        case .invalid, .failed, .rateLimited:
            /// here we get the current index of the failed api key from the api keys array
            guard let currentIndex: Int = apiAccessKeys.getMatchedIndex(for: key) else { return }
            /// if this the index of initial api key, we set it as the initial current index otherwise we skip to keep track of the initial index.
            initialAPIKeyIndex == nil ? setInitialAPIKeyIndex(currentIndex) : ()
            /// then we get the next available index after the failed api key index from the api keys array.
            let nextIndex: Int = apiAccessKeys.getNextIndex(currentIndex)
            
            /// next index must not equal to the initial api key index as it means we are back to the initial index again after a whole iteration.
            if nextIndex != initialAPIKeyIndex {
                let nextAPIAccessKey: String = apiAccessKeys[nextIndex]
                /// once we have the next available api key we check whether that api key is valid or not.
                /// if it's not valid the validation process iterates.
                await apiAccessKeyValidation(nextAPIAccessKey)
            } else {
                /// this line get executed when we reach the initial index after a whole iteration through the array.
                /// that means we're fucked. all the api keys are rate limited now. Congrates that means somewhat user base is currently using all the api keys.
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
