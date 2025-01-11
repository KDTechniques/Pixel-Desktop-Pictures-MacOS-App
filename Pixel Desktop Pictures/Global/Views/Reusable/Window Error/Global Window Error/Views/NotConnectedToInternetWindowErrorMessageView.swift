//
//  NotConnectedToInternetWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct NotConnectedToInternetWindowErrorMessageView: View {
    // MARK: - BODY
    var body: some View {
        Text("Make sure the Mac is connected to the internet.")
            .foregroundStyle(.secondary)
    }
}

// MARK: - PREVIEWS
#Preview("Not Connected to Internet Window Error Message View") {
    NotConnectedToInternetWindowErrorMessageView()
        .previewModifier
}
