//
//  CaseIterable Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

extension CaseIterable {
    /// Returns a random case from all cases of the conforming type.
    ///
    /// This method force unwraps the result of `randomElement()`, which is safe in the context of `CaseIterable`,
    /// as enums conforming to `CaseIterable` are expected to have at least one case.
    ///
    /// - Returns: A randomly selected case of the conforming type.
    static func random() -> Self {
        return allCases.randomElement()! // Note: The Force unwrap is safe in this context, so no need to return an optional by safe unwrapping it.
    }
}
