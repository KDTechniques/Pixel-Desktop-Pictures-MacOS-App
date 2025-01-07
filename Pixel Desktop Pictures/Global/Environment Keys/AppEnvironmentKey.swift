//
//  AppEnvironmentKey.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-07.
//

import SwiftUI

struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironmentModel = .mock
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironmentModel {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
