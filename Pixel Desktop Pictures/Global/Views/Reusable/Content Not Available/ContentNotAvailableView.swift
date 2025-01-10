//
//  ContentNotAvailableView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct ContentNotAvailableView: View {
    // MARK: - PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
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
                case .apiAccessKeyNotFound:
                    tabsVM.setTabSelection(.settings)
                case .noInternetConnection, .updatingCollectionItemNotFound:
                    ()
                case .apiAccessKeyError:
                    await apiAccessKeyManager.apiAccessKeyCheckup()
                }
            }
        }
        .padding()
        .padding(.bottom, (type == .noInternetConnection || type == .apiAccessKeyNotFound) ? 30 : 0)
    }
}

// MARK: - PREVIEWS
#Preview("Content Not Available View") {
    ContentNotAvailableView(type: .random())
        .frame(width: TabItemsModel.allWindowWidth)
        .background(Color.windowBackground)
        .environment(APIAccessKeyManager())
        .environment(TabsViewModel())
}
