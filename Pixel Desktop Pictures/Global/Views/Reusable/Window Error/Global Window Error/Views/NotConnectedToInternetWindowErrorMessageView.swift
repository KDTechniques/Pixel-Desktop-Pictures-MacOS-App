//
//  NotConnectedToInternetWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct NotConnectedToInternetWindowErrorMessageView: View {
    // MARK: - INJECTED BODY
    var body: some View {
        Text("Make sure the Mac is connected to the internet.")
    }
}

// MARK: - PREVIEWS
#Preview("Not Connected to Internet Window Error Message View") {
    WindowErrorView(model: GlobalWindowError.notConnectedToInternet)
        .padding()
        .previewModifier
}
