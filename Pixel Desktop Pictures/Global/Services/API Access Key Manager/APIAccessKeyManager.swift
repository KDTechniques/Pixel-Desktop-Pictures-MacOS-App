//
//  APIAccessKeyManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-07.
//

import Foundation

@MainActor
@Observable final class APIAccessKeyManager {
    // MARK: - PROPERTIES
    let defaults: UserDefaultsManager = .init()
    var apiAccessKeyStatus: APIAccessKeyValidityStatusModel = .notFound {
        didSet {
            guard oldValue != apiAccessKeyStatus else { return }
            
            Task {
                await onAPIAccessKeyStatusChange(apiAccessKeyStatus)
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Initialize API Access Key Manager
    func initializeAPIAccessKeyManager() async throws {
        try await getNAssignAPIAccessKeyStatusFromUserDefaults()
        print("API Access Key Manager is initialized!")
    }
    
    // MARK: - API Access Key Checkup
    func apiAccessKeyCheckup() async {
        guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
            apiAccessKeyStatus = .notFound
            return
        }
        
        await connectAPIAccessKey(key: apiAccessKey)
    }
    
    // MARK: - Connect API Access Key
    func connectAPIAccessKey(key: String) async {
        guard !key.isEmpty else { return }
        
        apiAccessKeyStatus = .validating
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: key)
        
        do {
            try await imageAPIService.validateAPIAccessKey()
            apiAccessKeyStatus = .connected
            await saveAPIAccessKeyToUserDefaults(key)
        } catch {
            print(error.localizedDescription)
            guard let urlError = error as? URLError else {
                apiAccessKeyStatus = .invalid
                return
            }
            
            switch urlError.code {
            case .notConnectedToInternet:
                apiAccessKeyStatus = .failed
            default:
                apiAccessKeyStatus = .invalid
            }
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - getAPIAccessKeyFromUserDefaults
    private func getAPIAccessKeyFromUserDefaults() async -> String? {
        guard let apiAccessKey: String = await defaults.get(key: .apiAccessKey) as? String else {
            return nil
        }
        
        return apiAccessKey
    }
    
    // MARK: - On API Access Key Status Change
    private func onAPIAccessKeyStatusChange(_ status: APIAccessKeyValidityStatusModel) async {
        do {
            switch status {
            case .notFound, .failed, .validating:
                try await saveAPIAccessKeyStatusToUserDefaults(.notFound)
            case .connected:
                try await saveAPIAccessKeyStatusToUserDefaults(.connected)
            case .invalid:
                try await saveAPIAccessKeyStatusToUserDefaults(.invalid)
            }
        } catch {
            print("Error: Saving `\(status)` status to user defaults. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save API Access Key to User Defaults
    private func saveAPIAccessKeyToUserDefaults(_ key: String) async {
        await defaults.save(key: .apiAccessKey, value: key)
    }
    
    // MARK: - Save API Access Key Status to User Defaults
    private func saveAPIAccessKeyStatusToUserDefaults(_ status: APIAccessKeyValidityStatusModel) async throws {
        try await defaults.saveModel(key: .apiAccessKeyStatusKey, value: status)
    }
    
    // MARK: - Get & Assign API Access Key Status from User Defaults
    private func getNAssignAPIAccessKeyStatusFromUserDefaults() async throws {
        guard let apiAccessKeyStatus: APIAccessKeyValidityStatusModel = try await defaults.getModel(key: .apiAccessKeyStatusKey, type: APIAccessKeyValidityStatusModel.self) else {
            apiAccessKeyStatus = .notFound
            return
        }
        
        self.apiAccessKeyStatus = apiAccessKeyStatus
    }
}
