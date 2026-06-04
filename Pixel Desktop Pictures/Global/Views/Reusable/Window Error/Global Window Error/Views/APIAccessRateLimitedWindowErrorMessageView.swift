//
//  APIRateLimitedWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct APIRateLimitedWindowErrorMessageView: View {
    // MARK: - BODY
    var body: some View {
        Text("Too many changes in a short period. Please wait an hour before retrying.")
    }
}

// MARK: - PREVIEWS
#Preview("API  Rate Limited Window Error Message View") {
    WindowErrorView(model: GlobalWindowErrorModel.apiRateLimited)
        .padding()
        .previewModifier
}
