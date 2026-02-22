//
//  SettingThingsUpView.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-02-22.
//

import SwiftUI

struct SettingThingsUpView: View {
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 2) {
            Text("Please Wait")
                .font(.headline)
            
            Text("Setting Things Up")
            
            ProgressView().scaleEffect(0.4)
        }
        .padding()
        .padding(.bottom, 30)
    }
}

// MARK: - PREVIEWS
#Preview("SettingThingsUpView") {
    PreviewView {
        SettingThingsUpView()
    }
    .previewModifier
}
