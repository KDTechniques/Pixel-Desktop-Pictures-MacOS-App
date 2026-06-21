//
//  OnboardingImageGridValues.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-05-31.
//

import Foundation

struct OnboardingImageGridValues {
    private static let widthRate: CGFloat = 16
    private static let heightRate: CGFloat = 9
    private static let size: CGFloat = 350
    private static let imageFrameWidth: CGFloat = size / (widthRate + heightRate) * widthRate
    static let imageFrameHeight: CGFloat = size / (widthRate + heightRate) * heightRate
    static let spacing: CGFloat = 5
    static let widthPatternRates: [CGFloat] = [2.5/3, 1, 1, 1.5/3]
    
    static let urlCases: [GridImageTypes] = [.car, .mountain, .dog, .abstract, .astronomy, .food, .colorful, .beach]
    
    static func getWidth(_ rate: CGFloat) -> CGFloat {
        return imageFrameWidth * rate
    }
    
    static func getImageGridWidth() -> CGFloat {
        var width: CGFloat = .zero
        let totalSpacing: CGFloat = spacing * 3
        
        for rate in widthPatternRates {
            width += getWidth(rate)
        }
        
        return width + totalSpacing
    }
}

extension OnboardingImageGridValues {
    enum GridImageTypes: String {
        case car = "https://images.unsplash.com/photo-1659427219918-b8bf97024d65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODV8fG5pc3NhbiUyMGd0ciUyMHdhbGxwYXBlcnxlbnwwfDB8MHx8fDA%3D"
        case colorful = "https://images.unsplash.com/photo-1488928741225-2aaf732c96cc?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTV8fGNvbG9yfGVufDB8MHwwfHx8MA%3D%3D"
        case dog = "https://images.unsplash.com/photo-1544568100-847a948585b9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fERvZ3xlbnwwfDB8MHx8fDA%3D"
        case mountain = "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bW9udGFpbnN8ZW58MHwwfDB8fHww"
        case beach = "https://images.unsplash.com/photo-1541417904950-b855846fe074?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGJlYWNofGVufDB8MHwwfHx8MA%3D%3D"
        case food = "https://images.unsplash.com/photo-1682862279256-b2a9e4f3d22c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fGZvb2R8ZW58MHwwfDB8fHww"
        case astronomy = "https://plus.unsplash.com/premium_photo-1690571200236-0f9098fc6ca9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8QXN0cm9ub215fGVufDB8MHwwfHx8MA%3D%3D"
        case abstract = "https://images.unsplash.com/photo-1633596683562-4a47eb4983c5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fEFic3RyYWN0fGVufDB8MHwwfHx8MA%3D%3D"
    }
}
