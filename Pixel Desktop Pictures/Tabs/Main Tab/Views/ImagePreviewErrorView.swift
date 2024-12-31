//
//  ImagePreviewErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct ImagePreviewErrorView: View {
    // MARK: - PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            errorText
            retryButton
        }
    }
}

// MARK: - PREVIEWS
#Preview("Image Preview Error View") {
    ImagePreviewErrorView()
        .frame(width: TabItems.allWindowWidth)
        .background(Color.windowBackground)
        .environment(MainTabViewModel())
}

// MARK: - EXTENSIONS
extension ImagePreviewErrorView {
    // MARK: - Error Text
    private var errorText: some View {
        VStack(spacing: 2) {
            Text("Failed to fetch content.")
                .font(.headline)
            
            Text("Make sure the Mac is connected to the internet.")
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Retry Button
    private var retryButton: some View {
        ButtonView(title: "Retry", type: .regular) { mainTabVM.retryConnection() }
            .padding()
    }
}
