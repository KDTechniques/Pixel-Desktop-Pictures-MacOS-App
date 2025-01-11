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
    func setTabContentHeightToTabsViewModelViewModifier(from tab: TabItemsModel) -> some View {
        return self.modifier(SetTabContentHeightToTabsViewModel(from: tab))
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
            .environment(
                CollectionsViewModel(
                    apiAccessKeyManager: .init(),
                    swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)))
            )
            .environment(RecentsTabViewModel())
            .environment(SettingsTabViewModel(appEnvironment: .mock))
            .environment(APIAccessKeyManager())
        //            .environment(try! ImageQueryURLModelSwiftDataManager(appEnvironment: .production))
        //            .environment(try! RecentImageURLModelSwiftDataManager(appEnvironment: .production))
        //            .environment(try! CollectionModelSwiftDataManager(appEnvironment: .production))
    }
    
    // MARK: - Get Bottom Popover Geometry Height
    func getBottomPopoverGeometryHeight(_ height: Binding<CGFloat>) -> some View {
        self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: BottomPopoverPreferenceKey.self, value: geo.frame(in: .local).height)
                }
                .onPreferenceChange(BottomPopoverPreferenceKey.self) { value in
                    height.wrappedValue = value
                }
            }
    }
}

// MARK: - VIEW MODIFIER STRUCTS

// MARK: On First Appear
fileprivate struct OnFirstAppear: ViewModifier {
    // MARK: INJECTED PROPERTIES
    let action: () -> Void
    
    // MARK: ASSIGNED PROPERTIES
    @State private var didAppear: Bool = false
    
    // MARK: INITIALIZER
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    // MARK: BODY
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !didAppear else { return }
                didAppear = true
                action()
            }
    }
}

// MARK: On First Task
fileprivate struct OnFirstTask: ViewModifier {
    // MARK: INJECTED PROPERTIES
    let action: () async -> Void
    
    // MARK: ASSIGNED PROPERTIES
    @State private var didAppear: Bool = false
    
    // MARK: INITIALIZER
    init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    // MARK: BODY
    func body(content: Content) -> some View {
        content
            .task {
                guard !didAppear else { return }
                didAppear = true
                await action()
            }
    }
}

// MARK: Set Tab Content Height to Tabs ViewModel
fileprivate struct SetTabContentHeightToTabsViewModel: ViewModifier {
    // MARK: PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    let tab: TabItemsModel
    
    // MARK: INITIALIZER
    init(from tab: TabItemsModel) {
        self.tab = tab
    }
    
    // MARK: BODY
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            tabsVM.setTabContentHeight(height: geo.size.height, from: tab)
                        }
                }
            }
    }
}

// MARK: - PREFERENCE KEYS

// MARK: Bottom Popover Preference Key
struct BottomPopoverPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
