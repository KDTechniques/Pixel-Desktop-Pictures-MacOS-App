//
//  HeaderView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - BODY
    var body: some View {
        HStack {
            LogoNTitleView()
            Spacer()
            TabItemsView()
        }
    }
}

// MARK: - PREVIEWS
#Preview("Header View") {
    HeaderView()
        .padding()
        .frame(width: Utilities.allWindowWidth)
        .background(Color.windowBackground)
}
