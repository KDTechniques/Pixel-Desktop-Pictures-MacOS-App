//
//  Observable Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

extension Observable {
    /// Creates a two-way Binding for a given KeyPath of the current type.
    ///
    /// - Parameter keyPath: A reference writable key path to the property.
    /// - Returns: A Binding that allows getting and setting the value.
    func binding<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
