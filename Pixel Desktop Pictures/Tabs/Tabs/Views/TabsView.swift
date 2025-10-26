//
//  TabsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI
import TipKit

struct TabsView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    @Environment(SettingsTabViewModel.self) private var settingsVM
    
    let tip: SampleTip = .init()
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .background(alignment: .top) { ErrorPopupView() }
            
            TabView(selection: Binding(get: { tabsVM.tabSelection }, set: { _ in })) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    tab.content
                        .frame(width: TabItem.allWindowWidth)
                        .tag(tab)
                }
                .background(TabBarHiderView())
            }
            .frame(height: tabsVM.selectedTabContentHeight)
            .tabViewStyle(.grouped)
            .zIndex(-1)
        }
        .frame(width: TabItem.allWindowWidth)
        .background(Color.windowBackground)
//        .alert(LaunchAtLoginAlertModel.title, isPresented: settingsVM.binding(\.showLaunchAtLoginAlert)) {
//            LaunchAtLoginAlertModel.actions {
//                settingsVM.launchAtLogin = true
//            }
//        } message: {
//            LaunchAtLoginAlertModel.message
//        }
        .onFirstAppearViewModifier {
            settingsVM.handleLaunchAtLoginAlertOnTabViewAppear()
        }
    }
}

// MARK: - PREVIEWS
#Preview("Tabs View") {
    TabsView()
        .previewModifier
}

struct SampleTip: Tip {
    var title: Text {
        Text("title goes here")
    }
    
    var message: Text? {
        Text("message goes here")
    }
}
