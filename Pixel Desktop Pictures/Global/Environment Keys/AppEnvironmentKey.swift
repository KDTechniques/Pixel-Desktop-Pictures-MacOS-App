//
//  AppEnvironmentKey.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-07.
//

import SwiftUI

struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = .mock
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
