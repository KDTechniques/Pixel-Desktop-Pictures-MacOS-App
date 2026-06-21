//
//  APIAccessKeyManager_KeyValidations.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-06-21.
//

import Foundation

extension APIKeyManager {
    func validateAPIKey(_ key: String) async {
        // We don't try to validate an api key when there's one already validating in the background.
        guard apiKeyValidationState != .validating else { return }
        
        // Start the API key validation process.
        setAPIKeyValidationState(.validating)
        
        // To validate the api key we must create an instance of Unsplash image api service by passing the given api key.
        let imageAPIService: UnsplashImageAPIService = .init(apiKey: key)
        
        do {
            try await imageAPIService.validateAPIKey() /// If the api key validation is successful, next line get executed otherwise it throws an error.
            
            // Handle Successful API  Key Validation
            /// here we save the valid api key to user defaults
            /// then assign the valid key to the api key property
            /// finally set the validity state to `.valid`
            saveAPIKeyToUserDefaults(key)
            setAPIKey(key)
            setAPIKeyValidationState(.valid)
            print("✅: Successful API key validation on: \(key)")
        } catch (let error) {
            // In case of api key invalidation we have to figure out a way to iterate through other available api keys from the api keys array and find a valid key.
            /// error can be due to not having connected to the internet, rate limited or invalid, so we need to handle it properly while maintaining better UX.
            let validationState: APIKeyValidityStates = Utilities.APIKeyValidityStateOnURLError(error)
            setAPIKeyValidationState(validationState)
            insertFailedAPIKeyIndexOn(key: key)
            Logger.log(errorModel.apiKeyValidationFailed(error).localizedDescription + ": \(key)")
        }
    }
    
    func validateNextAPIKey() async {
        Logger.log("🏃🏼‍♂️: Validating next API key.")
        guard let apiKey: String = getAPIKey() ?? getNextAvailableAPIKey() ?? apiKeys.first else { return }
        await validateAPIKey(apiKey)
    }
}
