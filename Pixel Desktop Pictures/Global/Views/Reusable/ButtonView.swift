//
//  ButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

enum ButtonTypes: CaseIterable {
    case regular, popup
}

struct ButtonView: View {
    // MARK: - PROPERTIES
    let title: String
    let showProgress: Bool
    let type: ButtonTypes
    let action: () -> Void
    
    // MARK: - PRIVATE PROPERTIES
    var foregroundColor: Color {
        switch type {
        case .regular:
            return .buttonForeground
        case .popup:
            return .popupButtonForeground
        }
    }
    
    var backgroundColor: Color {
        switch type {
        case .regular:
            return .buttonBackground
        case .popup:
            return .popupButtonBackground
        }
    }
    
    // MARK: - INITIALIZER
    init(title: String, showProgress: Bool = false, type: ButtonTypes, action: @escaping () -> Void) {
        self.title = title
        self.showProgress = showProgress
        self.type = type
        self.action = action
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .overlay(alignment: .trailing) {
                    if showProgress {
                        ProgressView()
                            .scaleEffect(0.4)
                            .offset(x: 30)
                    }
                }
                .foregroundStyle(foregroundColor)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(backgroundColor, in: .rect(cornerRadius: 5))
        }
        .buttonStyle(.plain)
        .disabled(showProgress)
    }
}

// MARK: - PREVIEWS
#Preview("Button View") {
    ButtonView(title: "Done", showProgress: .random(), type: .random()) {
        print("Action triggered!")
    }
    .padding()
    .previewModifier
}
