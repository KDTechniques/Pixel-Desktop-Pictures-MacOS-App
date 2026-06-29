//
//  DownloadButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import SwiftUI

struct DownloadButtonView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    
    // MARK: - BODY
    var body: some View {
        Button("Download") {
            Task { await downloadImage() }
        }
        .buttonStyle(.plain)
        .opacity(mainTabVM.downloadButtonProgressIndicatorState == .none ? 1 : 0)
        .overlay(alignment: .trailing) { overlay }
    }
}

// MARK: - PREVIEWS
#Preview("Download Button View") {
    DownloadButtonView()
        .padding()
        .previewModifier
}

// MARK: - EXTENTIONS
extension DownloadButtonView {
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .fontWeight(.semibold)
    }
    
    private var progressIndicator: some View {
        Image(systemName: "progress.indicator")
            .symbolEffect(.variableColor.iterative)
            .fontWeight(.semibold)
    }
    
    @ViewBuilder
    private var overlay: some View {
        switch mainTabVM.downloadButtonProgressIndicatorState {
        case .none:
            EmptyView()
            
        case .downloading:
            progressIndicator
            
        case .downloaded:
            checkmark
        }
    }
    
    // MARK: - FUNCTIONS
    private func downloadImage() async {
        await mainTabVM.prepareWithDeferredOperation(for: .download) {
            try await mainTabVM.downloadImageToDevice(environment: appEnvironment)
        }
    }
}
