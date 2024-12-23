//
//  ImagePreviewErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct ImagePreviewErrorView: View {
    var body: some View {
        VStack {
            HeaderView()
            
            // Error Message
            VStack(spacing: 2) {
                Text("Failed to fetch content.")
                    .font(.headline)
                
                Text("Make sure the Mac is connected to the internet.")
            }
            .padding(.vertical, 8)
            
            // Retry Button
            ButtonView(title: "Retry", type: .regular) {
                // set desktop pictire action goes here...
            }
        }
        .padding()
    }
}

#Preview("Image Preview Error View") {
    ImagePreviewErrorView()
        .frame(width: 375)
        .background(Color.windowBackground)
}
