//
//  LaunchAtLoginAlertModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-10.
//

import SwiftUI

struct LaunchAtLoginAlertModel {
    static let title: String = "Launch Pixel Desktop Pictures at Login?"
    static let message: Text = .init("This keeps your wallpapers changing automatically. You can turn it off anytime in Settings.")
    
    @ViewBuilder
    static func actions(defaultAction: @escaping () -> Void) -> some View {
        Button("Enable at Login") { defaultAction() }
        Button("Not Now", role: .cancel) { }
    }
}


struct LaunchAtLoginAlertButtonModel {
    let text: String
    let role: ButtonRole? = nil
    let action: () -> Void
}
