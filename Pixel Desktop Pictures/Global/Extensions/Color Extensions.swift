//
//  Color Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUICore

extension Color {
    // MARK: - Debug Random Color
    static var debug: Self {
        return .init(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
