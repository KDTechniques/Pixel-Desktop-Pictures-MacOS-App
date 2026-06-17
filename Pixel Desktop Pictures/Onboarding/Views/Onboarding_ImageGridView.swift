//
//  Onboarding_ImageGridView.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-05-31.
//

import SwiftUI
import SDWebImageSwiftUI

struct Onboarding_ImageGridView: View {
    // MARK: - INJECTED PROPERTIES
    let rates: [CGFloat]
    let urlCases: [OnboardingImageGridValues.GridImageTypes]
    
    // MARK: - INITIALIZER
    init(rates: [CGFloat], urlCases: [OnboardingImageGridValues.GridImageTypes]) {
        self.rates = rates
        self.closeRange = 0...rates.count-1
        self.urlCases = urlCases
    }
    
    // MARK: - ASSIGNED PROPERTIES
    private var closeRange: ClosedRange<Int>
    @State private var isSuccess: Bool = false
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: OnboardingImageGridValues.spacing) {
            ForEach(closeRange, id: \.self) { index in
                WebImage(url: .init(string: urlCases[index].rawValue), options: [.progressiveLoad])
                    .onSuccess { _, _, _ in isSuccess = true }
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: OnboardingImageGridValues.getWidth(rates[index]),
                        height: OnboardingImageGridValues.imageFrameHeight
                    )
                    .clipped()
                    .id(isSuccess == true ? "" : NetworkManager.shared.connectionStatus.rawValue)
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Onboarding_ImageGridView") {
    VStack(spacing: OnboardingImageGridValues.spacing) {
        Onboarding_ImageGridView(
            rates: OnboardingImageGridValues.widthPatternRates,
            urlCases: OnboardingImageGridValues.urlCases
        )
        
        Onboarding_ImageGridView(
            rates: OnboardingImageGridValues.widthPatternRates,
            urlCases: OnboardingImageGridValues.urlCases.reversed()
        )
    }
}
