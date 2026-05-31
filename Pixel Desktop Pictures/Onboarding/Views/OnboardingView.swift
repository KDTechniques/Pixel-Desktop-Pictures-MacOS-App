//
//  OnboardingView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-05-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct OnboardingView: View {
    // MARK: - INJECTED PROPERTIERS
    @Environment(\.colorScheme) private var colorScheme
    let action: () -> Void
    
    // MARK: - INITIALIZER
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var imageGridWidth: CGFloat = .zero
    
    // MARK: - BODY
    var body: some View {
        VStack {
            // Image Grid
            VStack(spacing: OnboardingImageGridValues.spacing) {
                Onboarding_ImageGridView(
                    rates: OnboardingImageGridValues.widthPatternRates,
                    urlCases: OnboardingImageGridValues.urlCases
                )
                
                Onboarding_ImageGridView(
                    rates: OnboardingImageGridValues.widthPatternRates.reversed(),
                    urlCases: OnboardingImageGridValues.urlCases.reversed()
                )
            }
            .getWidth($imageGridWidth)
            
            Onboarding_LogoNTextView()
            Onboarding_GuideView()
            
            ButtonView(title: "Got It", type: .regular) { action() }
                .padding(.horizontal)
        }
        .padding(.bottom)
        .frame(maxWidth: imageGridWidth, alignment: .top)
        .background(Color.windowBackground)
        .overlay { windowStroke(colorScheme) }
        .clipShape(.rect(cornerRadius: 10))
    }
}

// MARK: - PREVIEWS
#Preview("OnboardingView") {
    OnboardingView() { }
}

// MARK: - EXTENSIONS
extension OnboardingView {
    private func windowStroke(_ colorScheme: ColorScheme) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.clear)
            .stroke(Color.white.gradient.opacity(0.3), lineWidth: colorScheme == .dark ? 2 : 1.5)
    }
}

fileprivate extension View {
    func getWidth(_ width: Binding<CGFloat>) -> some View {
        self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: Onboarding_ImageGridPreferenceKey.self, value: geo.frame(in: .global).width)
                }
                .onPreferenceChange(Onboarding_ImageGridPreferenceKey.self) { value in
                    width.wrappedValue = value
                }
            }
    }
}
