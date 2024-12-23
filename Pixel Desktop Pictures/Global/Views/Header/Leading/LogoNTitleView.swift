//
//  LogoNTitleView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct LogoNTitleView: View {
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

#Preview("Logo & Title View") {
    LogoNTitleView()
        .padding()
        .frame(width: 375)
        .background(Color.windowBackground)
}
