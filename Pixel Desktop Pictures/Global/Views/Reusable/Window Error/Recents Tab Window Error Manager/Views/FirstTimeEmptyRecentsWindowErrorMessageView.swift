//
//  FirstTimeEmptyRecentsWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-26.
//

import SwiftUI

struct FirstTimeEmptyRecentsWindowErrorMessageView: View {
    // MARK: - BODY
    var body: some View {
        Text("Refresh to load the next images, and they will appear here.")
    }
}

// MARK: - PREVIEWS
#Preview("First Time Empty Recents Window ErrorMessage View") {
    WindowErrorView(model: RecentsTabWindowError.firstTimeEmptyRecents)
        .padding()
        .previewModifier
}

#Preview("Window Error View - Random") {
    WindowErrorView(model: GlobalWindowError.random())
        .padding()
        .previewModifier
}
