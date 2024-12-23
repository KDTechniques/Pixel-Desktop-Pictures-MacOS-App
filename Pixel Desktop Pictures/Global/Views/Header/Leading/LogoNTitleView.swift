//
//  LogoNTitleView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct LogoNTitleView: View {
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
    }
}

// MARK: - PREVIEWS
#Preview("Logo & Title View") {
    LogoNTitleView()
        .padding()
        .frame(width: Utilities.allWindowWidth)
        .background(Color.windowBackground)
}
