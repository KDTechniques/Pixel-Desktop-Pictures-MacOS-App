//
//  MainTab_DeferredOperations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-20.
//

import Foundation
import ObjectiveC

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
        guard
            deferredOperationsTask.isNil(), // Prevent re-entrance if an execution task is already running.
            !mainTabDeferredOperations.isEmpty,
            apiKeyManager.apiKeyValidationState == .valid else { return }
        
        // Launch a Task to track this run so subsequent calls are ignored until completion
        let task: Task = .init { [weak self] in
            guard let self else { return }
            await withTaskGroup(of: Void.self) { group in
                for operation in self.mainTabDeferredOperations {
                    group.addTask {
                        do {
                            Logger.log("🏃🏼‍♂️: Executing deferred operation: \(operation.type.rawValue).")
                            try await operation.action()
                        } catch {
                            await MainActor.run { [weak self] in
                                self?.addDeferredOperation(operation)
                            }
                        }
                        
                        let _ = await MainActor.run { [weak self] in
                            self?.mainTabDeferredOperations.remove(operation)
                        }
                    }
                }
            }
        }
        
        // Store the task reference so re-entrant calls can detect an in-progress run
        setDeferredOperationsTask(task)
        
        // Await completion and then clear the reference
        await task.value
        await MainActor.run { [weak self] in
            self?.setDeferredOperationsTask(nil)
            Logger.log("✅: Deferred tasks are now all executed.")
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

