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
    
    // MARK: - ASSIGNED PROPERTIES
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .recents) {
            Group {
                if recentsTabVM.recentsArray.isEmpty {
                    WindowErrorView(model: RecentsTabWindowError.recentsTabViewModelInitializationFailed)
                } else {
                    RecentsVGridScrollView()
                }
            }
            .frame(height: recentsTabVM.recentsArray.isEmpty ? .nan : TabItemsModel.recents.contentHeight)
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
        .onFirstTaskViewModifier {
            await apiAccessKeyManager.apiAccessKeyCheckup()
        }
}
