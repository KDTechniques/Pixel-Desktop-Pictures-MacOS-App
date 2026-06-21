//
//  MainTab_DeferredOperations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-20.
//

import Foundation

extension MainTabViewModel {
    // MARK: - PUBLIC FUNCTIONS
    func checkAPIKeyValidationBeforeExecution(operation: MainTabDeferredOperationModel) async {
        guard apiKeyManager.apiKeyValidationState == .valid else {
            // If the API key is not valid at the time, we add the action as a deferred operation to the <set>.
            addDeferredOperation(operation)
            return
        }
        
        // If API key is valid at the time, we execute the passed action.
        do {
            try await operation.action()
        } catch {
            addDeferredOperation(operation)
        }
    }
    
    func executeDeferredOperations() async {
        /// create a async concurrent task to execute all the available deferred operations at once asynchronously
        await withTaskGroup(of: Void.self) { group in
            
            // Loop through the set and add each operation to the group
            for operation in mainTabDeferredOperations {
                group.addTask {
                    do {
                        try await operation.action()
                    } catch {
                        await MainActor.run { [weak self] in
                            self?.addDeferredOperation(operation)
                        }
                    }
                    
                    // Hop back to the Main Actor to safely mutate the set
                    await MainActor.run { [weak self] in
                        self?.mainTabDeferredOperations.remove(operation)
                        return
                    }
                    
                    return
                }
            }
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func addDeferredOperation(_ operation: MainTabDeferredOperationModel) {
        // Same type of deferred operations can't be stored together.
        /// ex: user can't defer .download operation twice.
        /// that would make the user experience worst by downloading either the same image twice or download an unintended image.
        /// we remove the previously added deferred operations and only keep and execute the recent one of one type.
        
        // Removing duplicate deferred operation types
        let duplicateOperations: Set<MainTabDeferredOperationModel> = mainTabDeferredOperations.filter({ $0.type == operation.type })
        mainTabDeferredOperations.subtract(duplicateOperations)
        
        // Add the new deferred operation
        mainTabDeferredOperations.insert(operation)
    }
}
