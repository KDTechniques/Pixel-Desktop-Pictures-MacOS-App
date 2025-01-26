//
//  View Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import SwiftData

extension View {
    func setTabContentHeightToTabsViewModelViewModifier(from tab: TabItem) -> some View {
        return self.modifier(SetTabContentHeightToTabsViewModel(from: tab))
    }
    
    func onFirstAppearViewModifier(_ action: @escaping () -> Void) -> some View {
        return self.modifier(OnFirstAppear(action))
    }
    
    func onFirstTaskViewModifier(_ action: @escaping () async -> Void) -> some View {
        return self.modifier(OnFirstTask(action))
    }
    
    var previewModifier: some View {
        self
            .frame(width: TabItem.allWindowWidth)
            .background(Color.windowBackground)
            .environment(ErrorPopupViewModel.shared)
            .environment(TabsViewModel())
            .environment(MainTabViewModel(collectionsTabVM: .init(
                apiAccessKeyManager: .init(),
                collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock))),
                queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))),
                                          recentsTabVM: .init(recentManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))))
            )
            .environment(
                CollectionsTabViewModel(
                    apiAccessKeyManager: .init(),
                    collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production))),
                    queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production)))
                )
            )
            .environment(RecentsTabViewModel(recentManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))))
            .environment(SettingsTabViewModel(
                appEnvironment: .mock,
                mainTabVM: .init(
                    collectionsTabVM: .init(apiAccessKeyManager: .init(),
                                            collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock))),
                                            queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))),
                    recentsTabVM: .init(recentManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))))
            ))
            .environment(APIAccessKeyManager())
    }
}

// MARK: - VIEW MODIFIER STRUCTS

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

fileprivate struct SetTabContentHeightToTabsViewModel: ViewModifier {
    // MARK: PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    let tab: TabItem
    
    // MARK: INITIALIZER
    init(from tab: TabItem) {
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
