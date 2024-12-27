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
    
    // MARK: FUNCTIONS
    
    // MARK: - Set Tab Selection
    func setTabSelection(_ tab: TabItems) {
        tabSelection = tab
    }
}
