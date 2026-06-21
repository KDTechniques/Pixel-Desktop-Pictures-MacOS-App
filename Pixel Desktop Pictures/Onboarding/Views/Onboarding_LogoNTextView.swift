//
//  Onboarding_LogoNTextView.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-05-31.
//

import SwiftUI

struct Onboarding_LogoNTextView: View {
    // MARK: - ASSIGNED PROPERTIES
    let frameSize: CGFloat = 60
    
    // MARK: - BODY
    var body: some View {
        HStack {
            if let nsImage = NSApp.applicationIconImage {
                Image(nsImage: nsImage)
                    .resizable()
                    .frame(width: frameSize, height: frameSize)
            }
            
            Text("Pixel Desktop Pictures")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .kerning(0.5)
        }
        .padding(.vertical)
        .padding(.vertical)
    }
}

// MARK: - PREVIEWS
#Preview("Onboarding_LogoNTextView") {
    Onboarding_LogoNTextView()
}
