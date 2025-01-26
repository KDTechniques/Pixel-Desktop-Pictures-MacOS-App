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
    var apiAccessKeyStatus: APIAccessKeyValidityStatusModel = .notFound {
        didSet { apiAccessKeyStatus$ = apiAccessKeyStatus }
    }
    @ObservationIgnored @Published private var apiAccessKeyStatus$: APIAccessKeyValidityStatusModel = .notFound
    
    @ObservationIgnored private var apiAccessKey: String?
    private let errorModel: APIAccessKeyManagerErrorModel.Type = APIAccessKeyManagerErrorModel.self
    
    // MARK: - INTERNAL FUNCTIONS
    
    func initializeAPIAccessKeyManager() async {
        apiAccessKeyStatusSubscriber()
        await getNAssignAPIAccessKeyStatusFromUserDefaults()
        print("✅: `API Access Key Manager` has been initialized successfully.")
    }
    
    func getAPIAccessKey() async -> String? {
        guard let apiAccessKey else {
            guard let tempAPIAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                return nil
            }
            
            apiAccessKey = tempAPIAccessKey
            return tempAPIAccessKey
        }
        
        return apiAccessKey
    }
    
    func apiAccessKeyCheckup() async {
        // Get the API access key from UserDefaults to ensure we always work with a valid API key, in case changes happen.
        guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else { return }
        
        do {
            try await connectAPIAccessKey(key: apiAccessKey)
        } catch {
            print(errorModel.apiAccessKeyCheckupFailed)
        }
    }
    
    func connectAPIAccessKey(key: String) async throws {
        guard !key.isEmpty else {
            print(errorModel.EmptyAPIAccessKey.localizedDescription)
            throw errorModel.EmptyAPIAccessKey
        }
        
        apiAccessKeyStatus = .validating
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: key)
        
        do {
            try await imageAPIService.validateAPIAccessKey()
            apiAccessKeyStatus = .connected
            await saveAPIAccessKeyToUserDefaults(key)
        } catch  {
            print(error.localizedDescription)
            handleURLError(error)
        }
    }
    
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
                    print(urlError.localizedDescription)
                    return .connected
                }
            }()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func apiAccessKeyStatusSubscriber() {
        $apiAccessKeyStatus$
            .dropFirst(2)
            .removeDuplicates()
            .sink { status in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await onAPIAccessKeyStatusChange(status)
                }
            }
            .store(in: &cancellables)
    }
    
    private func getAPIAccessKeyFromUserDefaults() async -> String? {
        guard let apiAccessKey: String = await defaults.get(key: .apiAccessKey) as? String else {
            apiAccessKeyStatus = .notFound
            
            print(errorModel.apiAccessKeyNotFound.localizedDescription)
            return nil
        }
        
        return apiAccessKey
    }
    
    private func onAPIAccessKeyStatusChange(_ status: APIAccessKeyValidityStatusModel) async {
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
            print("❌: Saving `\(status)` status to user defaults. \(error.localizedDescription)")
        }
    }
    
    private func saveAPIAccessKeyToUserDefaults(_ key: String) async {
        await defaults.save(key: .apiAccessKey, value: key)
    }
    
    private func saveAPIAccessKeyStatusToUserDefaults(_ status: APIAccessKeyValidityStatusModel) async throws {
        try await defaults.saveModel(key: .apiAccessKeyStatusKey, value: status)
    }
    
    private func getNAssignAPIAccessKeyStatusFromUserDefaults() async {
        do {
            guard let apiAccessKeyStatus: APIAccessKeyValidityStatusModel = try await defaults.getModel(key: .apiAccessKeyStatusKey, type: APIAccessKeyValidityStatusModel.self) else {
                apiAccessKeyStatus = .notFound
                return
            }
            
            self.apiAccessKeyStatus = apiAccessKeyStatus
        } catch {
            print(errorModel.apiAccessKeyStatusNotFound.localizedDescription)
        }
    }
}
