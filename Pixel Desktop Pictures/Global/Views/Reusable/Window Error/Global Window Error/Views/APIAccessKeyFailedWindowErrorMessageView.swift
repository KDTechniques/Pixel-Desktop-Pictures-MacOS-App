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
        VStack(spacing: 10) {
            text
            relaunchAppButton
        }
    }
}

// MARK: - PREVIEWS
#Preview("APIKeyFailedWindowErrorMessageView") {
    APIKeyFailedWindowErrorMessageView()
        .multilineTextAlignment(.center)
        .padding()
        .previewModifier
}

extension APIKeyFailedWindowErrorMessageView {
    private var text: some View {
        Text("Relaunching the app may resolve the issue.")
    }
    
    private var relaunchAppButton: some View {
        Button {
            Utilities.quitNRelaunchApp()
        } label: {
            Text("Relaunch App")
                .underline()
                .foregroundStyle(Color.accentColor)
        }
        .buttonStyle(.plain)
    }
}
