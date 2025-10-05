//
//  RecentsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct RecentsTabView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(RecentsTabViewModel.self) private var recentsTabVM
    @Environment(MainTabViewModel.self) private var mainTabVM
    
    // MARK: - ASSIGNED PROPERTIES
    private let vGridValues: VGridValues.Type = VGridValues.self
    private var condition1: Bool { mainTabVM.currentImage != nil && recentsTabVM.recentsArray.isEmpty }
    private var condition2: Bool { mainTabVM.currentImage == nil && recentsTabVM.recentsArray.isEmpty }
    private var condition3: Bool { recentsTabVM.recentsArray.count <= 12 }
    private var recentItemsCount: Int { recentsTabVM.recentsArray.count }
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .recents) {
            
            Group {
                if condition1 {
                    WindowErrorView(model: RecentsTabWindowError.recentsTabViewModelInitializationFailed)
                } else if condition2 {
                    WindowErrorView(model: RecentsTabWindowError.firstTimeEmptyRecents)
                } else {
                    RecentsVGridScrollView()
                        .scrollDisabled(condition3)
                }
            }
            .frame(height: getHeight())
        }
        .environment(recentsTabVM)
    }
}

// MARK: - PREVIEWS
#Preview("Recents Tab View") {
    @Previewable @State var networkManager: NetworkManager = .shared
    @Previewable @State var apiAccessKeyManager: APIAccessKeyManager = .init()
    
    RecentsTabView()
        .environment(networkManager)
        .environment(apiAccessKeyManager)
        .previewModifier
}

// MARK: - EXTENSIONS
extension RecentsTabView {
    // MARK: - FUNCTIONS
    private func getHeight() -> CGFloat {
        return (condition1 || condition2)
        ? .nan
        : condition3 ? TabItem.recents.getRecentsDynamicContentHeight(itemsCount: recentItemsCount) : TabItem.recents.contentHeight
    }
}
