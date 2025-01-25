//
//  LogoNTitleView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct LogoNTitleView: View {
    // MARK: - ASSIGNED PROPERTIES
    @State private var showSubtitle: Bool = false
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Image(.logo)
            
            HStack(spacing: 3) {
                Text("Pixel")
                    .fontWeight(.semibold)
                
                Text("Desktop Pictures")
            }
        }
        .onTapGesture { handleTap() }
        .background(Color.windowBackground)
        .background(alignment: .top) { hiddenSubtitle }
        .animation(.default, value: showSubtitle)
    }
}

// MARK: - PREVIEWS
#Preview("Logo & Title View") {
    LogoNTitleView()
        .padding()
        .frame(width: TabItem.allWindowWidth)
        .background(Color.windowBackground)
}

// MARK: - EXTENSIONS
extension LogoNTitleView {
    @ViewBuilder
    private var hiddenSubtitle: some View {
        if showSubtitle {
            Text("The Unsplash Wallpapers MacOS App Killer 😈")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .minimumScaleFactor(0.6)
                .offset(y: 10)
                .padding(.top, 10)
                .transition(.move(edge: .top))
        }
    }
    
    // MARK: - FUNCTIONS
    
    private func handleTap() {
        Task {
            showSubtitle = true
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            showSubtitle = false
        }
    }
}
