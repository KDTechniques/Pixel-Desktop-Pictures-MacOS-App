//
//  FirstTimeEmptyRecentsWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-26.
//

import SwiftUI

struct FirstTimeEmptyRecentsWindowErrorMessageView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 4) {
                Text("Refresh on")
                
                Button {
                    tabsVM.setTabSelection(.main)
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "photo.fill")
                        Text("Preview")
                    }
                    .foregroundStyle(Color.accentColor)
                    .underline()
                }
                .buttonStyle(.plain)
                
                Text("tab to load the next images,")
            }
            
            Text("and they will appear here.")
        }
        
    }
}

// MARK: - PREVIEWS
#Preview("First Time Empty Recents Window ErrorMessage View") {
    WindowErrorView(model: RecentsTabWindowError.firstTimeEmptyRecents)
        .padding()
        .previewModifier
}

#Preview("Window Error View - Random") {
    WindowErrorView(model: GlobalWindowError.random())
        .padding()
        .previewModifier
}
