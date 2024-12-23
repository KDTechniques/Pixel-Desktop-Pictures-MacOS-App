//
//  HeaderView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            LogoNTitleView()
            Spacer()
            TabItemsView()
        }
    }
}

#Preview("Header View") {
    HeaderView()
        .padding()
        .frame(width: 375)
        .background(Color.windowBackground)
}
