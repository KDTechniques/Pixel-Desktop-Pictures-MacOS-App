//
//  APIAccessKeyNotFoundWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct APIAccessKeyNotFoundWindowErrorMessageView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 4) {
            Text("Go to")
            
            Button {
                tabsVM.setTabSelection(.settings)
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .foregroundStyle(Color.accentColor)
                .underline()
            }
            .buttonStyle(.plain)
            
            Text("tab to add one.")
        }
    }
}

// MARK: - PREVIEWS
#Preview("APIAccessKeyNotFoundWindowErrorMessageView") {
    WindowErrorView(model: GlobalWindowError.apiAccessKeyNotFound)
        .padding()
        .previewModifier
}
