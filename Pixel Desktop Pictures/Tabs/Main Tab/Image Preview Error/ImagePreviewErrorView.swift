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
                .padding()
            
            // Error Message
            VStack(spacing: 2) {
                Text("Failed to fetch content.")
                    .font(.headline)
                
                Text("Make sure the Mac is connected to the internet.")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // Retry Button
            Button {
                // set desktop pictire action goes here...
            } label: {
                Text("Retry")
                    .foregroundStyle(Color.buttonForeground)
                    .fontWeight(.medium)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
            .padding()
        }
    }
}

#Preview("Image Preview Error View") {
    ImagePreviewErrorView()
        .frame(width: 375)
        .background(.white)
}
