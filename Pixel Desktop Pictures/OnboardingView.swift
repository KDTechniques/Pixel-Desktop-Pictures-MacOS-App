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
    
    // MARK: - ASSIGNED PROPERTIES
    private let urlStrings: [String] = [
        "https://images.unsplash.com/photo-1488928741225-2aaf732c96cc?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTV8fGNvbG9yfGVufDB8MHwwfHx8MA%3D%3D", // Colorful
        "https://images.unsplash.com/photo-1544568100-847a948585b9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fERvZ3xlbnwwfDB8MHx8fDA%3D", // Dog
        "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bW9udGFpbnN8ZW58MHwwfDB8fHww", // Montain
        "https://images.unsplash.com/photo-1682862279256-b2a9e4f3d22c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fGZvb2R8ZW58MHwwfDB8fHww", // Food
        "https://images.unsplash.com/photo-1659427219918-b8bf97024d65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODV8fG5pc3NhbiUyMGd0ciUyMHdhbGxwYXBlcnxlbnwwfDB8MHx8fDA%3D", // Car
        "https://images.unsplash.com/photo-1633596683562-4a47eb4983c5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fEFic3RyYWN0fGVufDB8MHwwfHx8MA%3D%3D", // Colorful
        "https://images.unsplash.com/photo-1541417904950-b855846fe074?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGJlYWNofGVufDB8MHwwfHx8MA%3D%3D", // Beach
        "https://plus.unsplash.com/premium_photo-1690571200236-0f9098fc6ca9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8QXN0cm9ub215fGVufDB8MHwwfHx8MA%3D%3D" // Astronomy
    ].shuffled()
    
    @State private var gridWidth: CGFloat = .zero
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d"
        return formatter
    }()
    
    // MARK: - BODY
    var body: some View {
        VStack {
            // Image Grid
            VStack(spacing: OnboardingImageGridValues.spacing) {
                ImageGridView(fractions: OnboardingImageGridValues.widthPatternRate, urlStrings: urlStrings)
                ImageGridView(fractions: OnboardingImageGridValues.widthPatternRate.reversed(), urlStrings: urlStrings.reversed())
            }
            
            LogoNTextView()
            
            Rectangle()
                .fill(.black.opacity(0.1))
                .frame(height: 300)
                .overlay(alignment: .topTrailing) {
                    HStack(spacing: 16) {
                        Image(.logo)
                            .resizable()
                            .scaledToFit()
                        
                        Image(systemName: "speaker.wave.3.fill")
                        Image(systemName: "display")
                        Image(systemName: "wifi")
                        Image(systemName: "switch.2")
                        
                        HStack {
                            Text(dateFormatter.string(from: Date.now))
                            Text(Date.now.formatted(date: .omitted, time: .shortened))
                        }
                        .fontWeight(.regular)
                    }
                    .frame(height: 14)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .padding(.trailing, 15)
                    .background(.black.opacity(0.3))
                }
                .padding(.horizontal, 50)
                .padding(.bottom)
            
            ButtonView(title: "Get Started", type: .regular) {
                
            }
            .padding()
            .padding(.top, 50)
            
        }
        .padding(.bottom)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.windowBackground)
        .overlay { windowStroke(colorScheme) }
        .clipShape(.rect(cornerRadius: 10))
    }
}

// MARK: - PREVIEWS
#Preview("OnboardingView") {
    OnboardingView()
}

// MARK: - EXTENSIONS
extension OnboardingView {
    private func windowStroke(_ colorScheme: ColorScheme) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.clear)
            .stroke(Color.white.gradient.opacity(0.3), lineWidth: colorScheme == .dark ? 2 : 1.5)
    }
}

fileprivate struct ImageGridView: View {
    let fractions: [CGFloat]
    let urlStrings: [String]
    
    init(fractions: [CGFloat], urlStrings: [String]) {
        self.fractions = fractions
        self.closeRange = 0...fractions.count-1
        self.urlStrings = urlStrings
    }
    
    private var closeRange: ClosedRange<Int>
    
    var body: some View {
        HStack(spacing: OnboardingImageGridValues.spacing) {
            ForEach(closeRange, id: \.self) { index in
                WebImage(url: .init(string: urlStrings[index]))
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: OnboardingImageGridValues.getWidth(fractions[index]),
                        height: OnboardingImageGridValues.imageFrameHeight
                    )
                    .clipped()
            }
        }
    }
}

fileprivate struct LogoNTextView: View {
    let frameSize: CGFloat = 60
    
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
    }
}

struct OnboardingImageGridValues {
    private static let widthRate: CGFloat = 16
    private static let heightRate: CGFloat = 9
    private static let size: CGFloat = 300
    private static let imageFrameWidth: CGFloat = size / (widthRate + heightRate) * widthRate
    static let imageFrameHeight: CGFloat = size / (widthRate + heightRate) * heightRate
    
    static let spacing: CGFloat = 5
    static let widthPatternRate: [CGFloat] = [2.5/3, 1, 1, 1.5/3]
    
    static func getWidth(_ fraction: CGFloat) -> CGFloat {
        return imageFrameWidth * fraction
    }
    
}
