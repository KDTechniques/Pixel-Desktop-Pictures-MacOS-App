//
//  CollectionsGridView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct CollectionsGridView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let spacing: CGFloat = 8
    var columns: [GridItem] {
        .init(
            repeating: .init(.flexible(), spacing: spacing),
            count: 3
        )
    }
    var popOverAnimation: (Animation, AnyHashable) { (.smooth(duration: 0.3), isPresentedPopup) }
    @State private var isPresentedPopup: Bool = false
    @State private var popOverHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding()
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0...15, id: \.self) { index in
                        // Note: we should be use conditional view builders inside a foreach. try to figure it out later...
                        if index == 15 {
                            Button {
                                isPresentedPopup = true
                            } label: {
                                Rectangle()
                                    .fill(Color.collectionPlusFrameBackground)
                                    .frame(height: 70)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .font(.title)
                                            .foregroundStyle(Color.collectionPlusIcon)
                                    }
                            }
                            .buttonStyle(.plain)
                        } else {
                            Rectangle()
                                .fill(.black)
                                .frame(height: 70)
                                .overlay {
                                    Group {
                                        Image(systemName: "checkmark")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                            .padding(6)
                                            .opacity(index == 2 ? 1 : 0)
                                        
                                        Text("Nature")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                            .padding(8)
                                    }
                                    .foregroundStyle(.white)
                                }
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .overlay {
                Color.windowBackground
                    .opacity(isPresentedPopup ? 0.8 : 0)
                    .animation(popOverAnimation.0, value: popOverAnimation.1)
            }
            .overlay(alignment: .bottom) {
                AddNewCollectionView(isPresentedPopup: $isPresentedPopup)
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: PopOverPreferenceKey.self, value: geo.frame(in: .local).height)
                        }
                        .onPreferenceChange(PopOverPreferenceKey.self) { value in
                            popOverHeight = value
                        }
                    }
                    .offset(y: isPresentedPopup ? 0 : popOverHeight)
                    .animation(popOverAnimation.0, value: popOverAnimation.1)
            }
        }
        .background(Color.windowBackground)
        .onTapGesture {
            isPresentedPopup = false
        }
    }
}

#Preview("Collections Grid View") {
    CollectionsGridView()
        .frame(width: 375, height: 282)
        .background(Color.windowBackground)
}

struct PopOverPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
