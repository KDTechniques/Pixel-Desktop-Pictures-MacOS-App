//
//  TabsViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import Foundation

@MainActor
@Observable final class TabsViewModel {
    // MARK: - ASSIGNED PROPERTIES
    private(set) var tabSelection: TabItem = .main
    private(set) var selectedTabContentHeight: CGFloat = .infinity
    
    // MARK: - PUBLIC FUNCTIONS
    
    func setTabSelection(_ tab: TabItem) {
        tabSelection = tab
        Logger.log("✅: Tab selection has been assigned.")
    }
    
    func setTabContentHeight(height: CGFloat, from tab: TabItem) {
        guard tab == tabSelection else { return }
        selectedTabContentHeight = height
    }
}
