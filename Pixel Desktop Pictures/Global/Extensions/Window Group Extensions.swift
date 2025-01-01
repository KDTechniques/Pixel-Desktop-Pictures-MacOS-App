//
//  Window Group Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-01.
//

import SwiftUI
import SwiftData

extension WindowGroup {
    // MARK: - Get Model Containers Window Group Modifier
    func getModelContainersViewModifier(in environment: AppEnvironmentModel, for models: [any PersistentModel.Type]) -> some Scene {
        return self
            .modelContainer(for: models, inMemory: environment == .mock ? true : false)
    }
}
