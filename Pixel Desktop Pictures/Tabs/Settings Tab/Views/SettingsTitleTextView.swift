//
//  SettingsTitleTextView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct SettingsTitleTextView: View {
    // MARK: - BODY
    var body: some View {
        Text("Settings")
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .bottom])
    }
}

// MARK: - PREVIEWS
#Preview("Settings Title Text View") {
    SettingsTitleTextView()
        .previewModifier
}
