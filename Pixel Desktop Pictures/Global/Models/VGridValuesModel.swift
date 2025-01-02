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
}
