//
//  TabBarHiderView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-30.
//

import SwiftUI

// Note: Add this view to one of the Tab Views or to the ForEach as a background
struct TabBarHiderView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        return .init()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        Task { @MainActor in
            guard let tabview = nsView.superview?.superview?.superview as? NSTabView else { return }
            
            tabview.tabViewType = .noTabsNoBorder
            tabview.tabViewBorderType = .none
            tabview.tabPosition = .none
        }
    }
}
