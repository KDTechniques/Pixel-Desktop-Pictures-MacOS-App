//
//  View Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import SwiftData

extension View {
    // MARK: - Set Tab Content Height To Tabs ViewModel View Modifier
    var setTabContentHeightToTabsViewModelViewModifier: some View {
        return self.modifier(SetTabContentHeightToTabsViewModel())
    }
    
    // MARK: - On First Appear View Modifier
    func onFirstAppearViewModifier(_ action: @escaping () -> Void) -> some View {
        return self.modifier(OnFirstAppear(action))
    }
    
    // MARK: - On First Task View Modifier
    func onFirstTaskViewModifier(_ action: @escaping () async -> Void) -> some View {
        return self.modifier(OnFirstTask(action))
    }
    
    // MARK: - Preview View Modifier
    var previewModifier: some View {
        self
            .frame(width: TabItemsModel.allWindowWidth)
            .background(Color.windowBackground)
            .environment(TabsViewModel())
            .environment(MainTabViewModel())
            .environment(CollectionsViewModel())
            .environment(RecentsTabViewModel())
            .environment(SettingsTabViewModel(appEnvironment: .mock))
            .environment(APIAccessKeyManager())
    }
}

// MARK: VIEW MODIFIER STRUCTS

// MARK: - On First Appear
fileprivate struct OnFirstAppear: ViewModifier {
    // MARK: - INJECTED PROPERTIES
    let action: () -> Void
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var didAppear: Bool = false
    
    // MARK: - INITIALIZER
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    // MARK: - BODY
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !didAppear else { return }
                didAppear = true
                action()
            }
    }
}

// MARK: - On First Task
fileprivate struct OnFirstTask: ViewModifier {
    // MARK: - INJECTED PROPERTIES
    let action: () async -> Void
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var didAppear: Bool = false
    
    // MARK: - INITIALIZER
    init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    // MARK: - BODY
    func body(content: Content) -> some View {
        content
            .task {
                guard !didAppear else { return }
                didAppear = true
                await action()
            }
    }
}

// MARK: - Set Tab Content Height to Tabs ViewModel
fileprivate struct SetTabContentHeightToTabsViewModel: ViewModifier {
    @Environment(TabsViewModel.self) private var tabsVM
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            tabsVM.setTabContentHeight(geo.size.height)
                        }
                }
            }
    }
}
