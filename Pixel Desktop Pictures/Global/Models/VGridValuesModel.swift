//
//  VGridValuesModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct VGridValuesModel {
    
    static let spacing: CGFloat = 8
    static var columns: [GridItem] {
        .init(
            repeating: .init(.flexible(), spacing: spacing),
            count: 3
        )
    }
    static let height: CGFloat = 70
    private static let horizontalPadding: CGFloat = 16*2
    static var width: CGFloat {
        (TabItemsModel.allWindowWidth - horizontalPadding - (spacing*2)) / 3
    }
    static let overlayColor: Color = .black.opacity(0.4)
}
