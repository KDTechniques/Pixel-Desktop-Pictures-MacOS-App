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
    private let defaults: UserDefaultsManager = .shared
    private var cancellables: Set<AnyCancellable> = []
    
    /// Current status of the API access key, which updates and triggers status change handling logic.
    var apiAccessKeyStatus: APIAccessKeyValidityStatus = .notFound {
        didSet { apiAccessKeyStatus$ = apiAccessKeyStatus }
    }
    @ObservationIgnored @Published private var apiAccessKeyStatus$: APIAccessKeyValidityStatus = .notFound
    
    @ObservationIgnored private var apiAccessKey: String?
    private let errorModel: APIAccessKeyManagerError.Type = APIAccessKeyManagerError.self
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Initializes the API Access Key Manager.
    ///
    /// Sets up status subscribers and retrieves the stored API access key status.
    /// Logs successful initialization.
    func initializeAPIAccessKeyManager() async {
        apiAccessKeyStatusSubscriber()
        await getNAssignAPIAccessKeyStatusFromUserDefaults()
        Logger.log("✅: `API Access Key Manager` has been initialized.")
    }
    
    /// Retrieves the current API access key.
    ///
    /// - Returns: The stored API access key or nil if not found.
    /// - Fetches key from UserDefaults if not already in memory.
    func getAPIAccessKey() async -> String? {
        guard let apiAccessKey else {
            guard let tempAPIAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                return nil
            }
            
            apiAccessKey = tempAPIAccessKey
            return tempAPIAccessKey
        }
        
        Logger.log("✅: API access key has been returned.")
        return apiAccessKey
    }
    
    /// Performs a validity check on the stored API access key.
    ///
    /// Retrieves the key from UserDefaults and attempts to connect.
    /// Logs an error if the checkup fails.
    func apiAccessKeyCheckup() async {
        // Get the API access key from UserDefaults to ensure we always work with a valid API key, in case changes happen.
        guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else { return }
        
        do {
            try await connectAPIAccessKey(key: apiAccessKey)
            Logger.log("✅: API access key checkup has been completed.")
        } catch {
            Logger.log(errorModel.apiAccessKeyCheckupFailed.localizedDescription)
        }
    }
    
    /// Validates and connects an API access key.
    ///
    /// - Parameter key: The API access key to validate.
    /// - Throws: Errors related to key validation or connection.
    /// - Updates the access key status based on validation result.
    func connectAPIAccessKey(key: String) async throws {
        // Exit early if the provided key is empty.
        guard !key.isEmpty else {
            Logger.log(errorModel.EmptyAPIAccessKey.localizedDescription)
            throw errorModel.EmptyAPIAccessKey
        }
        
        // Set the status to `validating` and proceeed.
        apiAccessKeyStatus = .validating
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: key)
        
        do {
            // Validate the key and set the status to `connected`, and then save the key to user defaults.
            try await imageAPIService.validateAPIAccessKey()
            apiAccessKeyStatus = .connected
            await saveAPIAccessKeyToUserDefaults(key)
            Logger.log("✅: API access key has been connected.")
        } catch  {
            Logger.log(error.localizedDescription)
            handleURLError(error)
        }
    }
    
    /// Handles URL-related errors during API access key validation.
    ///
    /// - Parameter error: The error encountered during key validation.
    /// - Determines and sets the appropriate API access key status.
    func handleURLError(_ error: Error?) {
        if let urlError = error as? URLError {
            apiAccessKeyStatus = {
                switch urlError.code {
                case .notConnectedToInternet:
                    return .failed
                case .clientCertificateRejected:
                    return .rateLimited
                case .userAuthenticationRequired:
                    return .invalid
                default:
                    Logger.log(urlError.localizedDescription)
                    return .connected
                }
            }()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Subscribes to changes in the API access key status.
    ///
    /// Sets up a Combine subscriber to handle status changes and trigger appropriate actions.
    private func apiAccessKeyStatusSubscriber() {
        $apiAccessKeyStatus$
            .dropFirst(2)
            .removeDuplicates()
            .sink { status in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    Logger.log("✅: API access key status subscriber got triggered.")
                    await onAPIAccessKeyStatusChange(status)
                }
            }
            .store(in: &cancellables)
    }
    
    /// Retrieves the API access key from UserDefaults.
    ///
    /// - Returns: The stored API access key or nil if not found.
    /// - Updates the access key status if no key is present.
    private func getAPIAccessKeyFromUserDefaults() async -> String? {
        guard let apiAccessKey: String = await defaults.get(key: .apiAccessKey) as? String else {
            apiAccessKeyStatus = .notFound
            Logger.log(errorModel.apiAccessKeyNotFound.localizedDescription)
            return nil
        }
        
        Logger.log("✅: API access key has been return.")
        return apiAccessKey
    }
    
    /// Handles changes in the API access key status.
    ///
    /// - Parameter status: The new API access key status.
    /// - Saves the status to UserDefaults based on the current status.
    private func onAPIAccessKeyStatusChange(_ status: APIAccessKeyValidityStatus) async {
        do {
            switch status {
            case .notFound, .validating, .failed:
                try await saveAPIAccessKeyStatusToUserDefaults(.notFound)
            case .invalid:
                try await saveAPIAccessKeyStatusToUserDefaults(.invalid)
            case .connected, .rateLimited:
                try await saveAPIAccessKeyStatusToUserDefaults(.connected)
            }
        } catch {
            Logger.log("❌: Saving `\(status)` status to user defaults. \(error.localizedDescription)")
        }
    }
    
    /// Saves the API access key to UserDefaults.
    ///
    /// - Parameter key: The API access key to be stored.
    private func saveAPIAccessKeyToUserDefaults(_ key: String) async {
        await defaults.save(key: .apiAccessKey, value: key)
        Logger.log("✅: API access key has been saved to user defaults.")
    }
    
    /// Saves the API access key status to UserDefaults.
    ///
    /// - Parameter status: The API access key status to be stored.
    /// - Throws: Errors related to saving the status.
    private func saveAPIAccessKeyStatusToUserDefaults(_ status: APIAccessKeyValidityStatus) async throws {
        try await defaults.saveModel(key: .apiAccessKeyStatusKey, value: status)
        Logger.log("✅: API access key status has been saved to user defaults.")
    }
    
    /// Retrieves and assigns the API access key status from UserDefaults.
    ///
    /// Sets the current API access key status based on the stored value.
    /// Defaults to .notFound if no status is found.
    private func getNAssignAPIAccessKeyStatusFromUserDefaults() async {
        do {
            guard let apiAccessKeyStatus: APIAccessKeyValidityStatus = try await defaults.getModel(key: .apiAccessKeyStatusKey, type: APIAccessKeyValidityStatus.self) else {
                apiAccessKeyStatus = .notFound
                return
            }
            
            self.apiAccessKeyStatus = apiAccessKeyStatus
            Logger.log("✅: API access key status has been fetched and assigned from user defaults.")
        } catch {
            Logger.log(errorModel.apiAccessKeyStatusNotFound.localizedDescription)
        }
    }
}
