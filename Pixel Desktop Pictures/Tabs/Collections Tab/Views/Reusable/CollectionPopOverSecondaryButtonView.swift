//
//  CollectionPopOverSecondaryButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI

struct CollectionPopOverSecondaryButtonView: View {
    // MARK: - PROPERTIES
    let title: String
    let systemImageName: String
    let foregroundColor: Color
    let showProgress: Bool
    let action: () -> Void
    
    // MARK: - INITIALIZER
    init(title: String, systemImageName: String, foregroundColor: Color, showProgress: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.systemImageName = systemImageName
        self.foregroundColor = foregroundColor
        self.showProgress = showProgress
        self.action = action
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: systemImageName)
                .overlay(alignment: .trailing) {
                    if showProgress {
                        ProgressView()
                            .scaleEffect(0.4)
                            .offset(x: 30)
                    }
                }
                .foregroundStyle(.white)
                .frame(height: 31)
                .frame(maxWidth: .infinity)
                .background(foregroundColor)
                .clipShape(.rect(cornerRadius: 5))
        }
        .buttonStyle(.plain)
        .disabled(showProgress)
    }
}

// MARK: - PREVIEWS
#Preview("Collection PopOver Secondary Button View") {
    CollectionPopOverSecondaryButtonView(title: "Delete", systemImageName: "trash.fill", foregroundColor: .red, showProgress: true) {}
        .padding()
        .previewModifier
}
