//
//  MainTab_DeferredOperations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-20.
//

import Foundation

extension MainTabViewModel {
    // MARK: - PUBLIC FUNCTIONS
    func prepareWithDeferredOperation(for type: MainTabDeferredOperationTypes, _ action: @escaping () async throws -> Void) async {
        do {
            try await action()
        } catch {
            let operation: MainTabDeferredOperationModel = .init(type: type) { try await action() }
            await checkAPIKeyValidationBeforeExecution(operation: operation)
        }
    }
    
    func executeDeferredOperations() async {
        guard apiKeyManager.apiKeyValidationState == .valid else { return }
        
        /// create a async concurrent task to execute all the available deferred operations at once asynchronously
        await withTaskGroup(of: Void.self) { group in
            // Loop through the set and add each operation to the group
            for operation in mainTabDeferredOperations {
                group.addTask {
                    do {
                        Logger.log("🏃🏼‍♂️: Executing deferred operation: \(operation.type.rawValue).")
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
    private func checkAPIKeyValidationBeforeExecution(operation: MainTabDeferredOperationModel) async {
        guard apiKeyManager.apiKeyValidationState == .valid else {
            // If the API key is not valid at the time, we add the action as a deferred operation to a <set>.
            addDeferredOperation(operation)
            return
        }
        
        // If API key is valid at the time, we execute the passed action.
        do {
            try await operation.action()
        } catch { // If the operation still fails for some reason we add it again to the deferred operations set.
            addDeferredOperation(operation)
        }
    }
    
    private func addDeferredOperation(_ operation: MainTabDeferredOperationModel) {
        // Same type of deferred operations can't be stored together.
        /// ex: user can't defer .download operation twice.
        /// that would make the user experience worst by downloading either the same image twice or download an unintended image.
        /// we remove the previously added deferred operations by its type and only keep and execute the recent one of one type.
        
        // Removing duplicate deferred operation types
        let duplicateOperations: Set<MainTabDeferredOperationModel> = mainTabDeferredOperations.filter({ $0.type == operation.type })
        mainTabDeferredOperations.subtract(duplicateOperations)
        
        // Add the new deferred operation
        mainTabDeferredOperations.insert(operation)
        Logger.log("⚠️: Deferred operation is added: \(operation.type.rawValue).")
    }
}
