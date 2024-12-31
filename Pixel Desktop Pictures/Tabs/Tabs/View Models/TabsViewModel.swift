//
//  TabsViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import Foundation

@MainActor
@Observable final class TabsViewModel {
    // MARK: - PROPERTIES
    private(set) var tabSelection: TabItems = .main
    private(set) var selectedTabContentHeight: CGFloat = .infinity
    
    // MARK: FUNCTIONS
    
    // MARK: - Set Tab Selection
    func setTabSelection(_ tab: TabItems) {
        tabSelection = tab
    }
    
    // MARK: - Set Tab Content Height
    func setTabContentHeight(_ height: CGFloat) {
        selectedTabContentHeight = height
    }
}
