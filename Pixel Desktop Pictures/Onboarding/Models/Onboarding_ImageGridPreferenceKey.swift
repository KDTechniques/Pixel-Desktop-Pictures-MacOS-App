//
//  Onboarding_ImageGridPreferenceKey.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-05-31.
//

import SwiftUI

struct Onboarding_ImageGridPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
