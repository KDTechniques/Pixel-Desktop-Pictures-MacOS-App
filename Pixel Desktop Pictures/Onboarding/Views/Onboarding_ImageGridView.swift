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
    @State private var id: String = UUID().uuidString
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: OnboardingImageGridValues.spacing) {
            ForEach(closeRange, id: \.self) { index in
                WebImage(
                    url: .init(string: urlCases[index].rawValue),
                    options: [.progressiveLoad],
                    context: [
                        .storeCacheType: SDImageCacheType.none.rawValue,
                        .originalStoreCacheType: SDImageCacheType.none.rawValue
                    ]
                )
                .onSuccess { _, _, _ in isSuccess = true }
                .onFailure { _ in isSuccess = false }
                .placeholder { placeholder }
                .resizable()
                .scaledToFill()
                .frame(
                    width: OnboardingImageGridValues.getWidth(rates[index]),
                    height: OnboardingImageGridValues.imageFrameHeight
                )
                .background(placeholder)
                .clipped()
                .id(id)
                .onChange(of: NetworkManager.shared.connectionStatus) { onNetworkConnectionChange($1) }
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

#Preview("OnboardingView") {
    OnboardingView() { }
}

// MARK: - EXTENSIONS
extension Onboarding_ImageGridView {
    private var placeholder: some View {
        Color.placeholder
    }
    
    private func onNetworkConnectionChange(_ status: InternetConnectionStatus) {
        guard !isSuccess, status == .connected else { return }
        id = UUID().uuidString
    }
}
