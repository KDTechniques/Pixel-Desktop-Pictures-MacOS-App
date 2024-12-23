//
//  View Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUICore

extension View {
    func previewViewModifier(_ setPadding: Bool = true) -> some View {
        self
            .padding(setPadding ? 20 : 0)
            .frame(width: 375)
            .background(.white)
    }
}
