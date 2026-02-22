//
//  APIKeyFailedWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-02.
//

import SwiftUI

struct APIKeyFailedWindowErrorMessageView: View {
    // MARK: - BODY
    var body: some View {
        Text("If the issue continues after restarting the app, please wait for the next update.")
    }
}

// MARK: - PREVIEWS
#Preview("APIKeyFailedWindowErrorMessageView") {
    APIKeyFailedWindowErrorMessageView()
        .previewModifier
}
