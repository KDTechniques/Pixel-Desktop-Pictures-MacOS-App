//
//  ImageContainerOverlayCenterView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUI

struct ImageContainerOverlayCenterView: View {
    // MARK: - PROPERTIES
    let centerItem: ImageContainerCenterItemsModel
    let action: () -> Void
    
    // MARK: - INITIALIZER
    init(centerItem: ImageContainerCenterItemsModel, action: @escaping () -> Void) {
        self.centerItem = centerItem
        self.action = action
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            action()
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
            ImageContainerOverlayCenterView(centerItem: .retryIcon/*.random()*/) {
                print("Button Clicked!")
            }
        }
}

extension ImageContainerOverlayCenterView {
    // MARK: - Button Label
    private var buttonLabel:some View {
        Group {
            switch centerItem {
            case .retryIcon:
                Image(systemName: "arrow.trianglehead.2.clockwise")
                    .fontWeight(.semibold)
            case .progressView:
                Image(systemName: "progress.indicator")
                    .symbolEffect(.variableColor.iterative.hideInactiveLayers)
            }
        }
        .foregroundStyle(.white)
        .font(.title2)
        .fontWeight(.semibold)
        .frame(width: 45, height: 35)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
    }
}
