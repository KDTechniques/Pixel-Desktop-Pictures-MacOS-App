//
//  ImageGridView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct ImageGridView: View {
    
    let spacing: CGFloat = 8
    var columns: [GridItem] {
        .init(
            repeating: .init(.flexible(), spacing: spacing),
            count: 3
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding()
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0...20, id: \.self) { _ in
                        Rectangle()
                            .fill(.red)
                            .frame(height: 70)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview("Image Grid View") {
    ImageGridView()
        .frame(width: 375, height: 360)
        .background(.white)
}
