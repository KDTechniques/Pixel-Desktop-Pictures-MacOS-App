//
//  ScrollPageUpNDownView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-04.
//

import SwiftUI

struct ScrollPageUpNDownView: View {
    // MARK: - INJECTED PROPERTIES
    @Binding var scrollID: String
    @Binding var direction: UnitPoint?
    let key: KeyEquivalent
    
    // MARK: - INITIAIZER
    init(scrollID: Binding<String>, direction: Binding<UnitPoint?>, key: KeyEquivalent) {
        _scrollID = scrollID
        _direction = direction
        self.key = key
    }
    
    // MARK: - BODY
    var body: some View {
        Button("") {
            scrollID = UUID().uuidString
            direction = (key == .pageUp) ? .top : .bottom
        }
        .opacity(0)
        .allowsHitTesting(false)
        .keyboardShortcut(key, modifiers: [])
    }
}
