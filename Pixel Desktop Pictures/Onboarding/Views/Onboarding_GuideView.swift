//
//  Onboarding_GuideView.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-05-31.
//

import SwiftUI

struct Onboarding_GuideView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Click on the")
                Image(.logo)
                Text("icon in the top-left corner of the Menu Bar to open the app.")
            }
            .font(.title3)
            
            Image(colorScheme == .dark ? .macbookDark : .macbookLight)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding(.bottom)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Onboarding_GuideView") {
    Onboarding_GuideView()
}

#Preview("OnboardingView") {
    OnboardingView() { }
}
