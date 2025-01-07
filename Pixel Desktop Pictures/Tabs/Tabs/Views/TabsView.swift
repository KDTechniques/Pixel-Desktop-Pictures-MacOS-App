//
//  TabsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI

struct TabsView: View {
    // MARK: - PROPERTIES
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var tabsVM: TabsViewModel = .init()
    let alertManager: AlertsManager = .shared
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            TabView(selection: Binding(get: { tabsVM.tabSelection }, set: { _ in })) {
                ForEach(TabItemsModel.allCases, id: \.self) { tab in
                    tab.content
                        .tag(tab)
                }
                .background(TabBarHiderView())
            }
            .frame(height: tabsVM.selectedTabContentHeight)
            .tabViewStyle(.grouped)
        }
        .frame(width: TabItemsModel.allWindowWidth)
        .background(Color.windowBackground)
        .alert(isPresented: alertManager.binding(\.isPresented), error: alertManager.error) { error in
            Text(error.errorDescription ?? "No Title")
        } message: { error in
            
        }
        .environment(tabsVM)
    }
}

// MARK: - PREVIEWS
#Preview("Tabs View") {
    TabsView()
}
