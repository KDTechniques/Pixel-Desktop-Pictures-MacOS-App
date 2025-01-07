//
//  ContentNotAvailableView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct ContentNotAvailableView: View {
    // MARK: - PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    @Environment(TabsViewModel.self) private var tabsVM
    let type: ContentNotAvailableModel
    
    // MARK: - INITIALIZER
    init(type: ContentNotAvailableModel) {
        self.type = type
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 2) {
            Text(type.title)
                .font(.headline)
            
            type.description {
                switch type {
                case .apiAccessKeyNotFound, .apiAccessKeyError:
                    tabsVM.setTabSelection(.settings)
                case .noInternetConnection: ()
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.bottom)
        .padding(.horizontal, 25)
    }
}

// MARK: - PREVIEWS
#Preview("Content Not Available View") {
    ContentNotAvailableView(type: .random())
        .frame(width: TabItemsModel.allWindowWidth)
        .background(Color.windowBackground)
        .environment(MainTabViewModel())
        .environment(TabsViewModel())
}
