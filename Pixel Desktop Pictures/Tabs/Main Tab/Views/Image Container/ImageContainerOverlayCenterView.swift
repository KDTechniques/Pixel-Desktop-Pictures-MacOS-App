//
//  ImageContainerOverlayCenterView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUI

struct ImageContainerOverlayCenterView: View {
    @Environment(MainTabViewModel.self) private var mainTabsVM
    // MARK: - PROPERTIES
    let centerItem: ImageContainerCenterItems
    let action: () async -> Void
    
    // MARK: - INITIALIZER
    init(centerItem: ImageContainerCenterItems, action: @escaping () async -> Void) {
        self.centerItem = centerItem
        self.action = action
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            Task { await action() }
        } label: {
            buttonLabel
        }
        .buttonStyle(.plain)
    }
}

// MARK: - PREVIEWS
#Preview("Image Preview Image Container Overlay Center View") {
    Color.debug
        .overlay {
            ImageContainerOverlayCenterView(centerItem: .random()) {
                Logger.log("Button Clicked!")
            }
            .previewModifier
        }
}

// MARK: - EXTENSIONS
extension ImageContainerOverlayCenterView {
    // MARK: - Button Label
    private var buttonLabel:some View {
        Group {
            switch centerItem {
            case .retryIcon:
                Image(systemName: "arrow.trianglehead.2.clockwise")
                    .fontWeight(.semibold)
            case .progressView:
                ProgressView()
                    .scaleEffect(0.6)
            }
        }
        .foregroundStyle(.white)
        .font(.title2)
        .fontWeight(.semibold)
        .frame(width: 45, height: 35)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
    }
}
