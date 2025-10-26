//
//  LaunchAtLoginAlertModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-10.
//

import SwiftUI

struct LaunchAtLoginAlertModel {
    private static let title: String = "Launch Pixel Desktop Pictures at Login?"
    private static let message: String = "This keeps your wallpapers changing automatically. You can turn it off anytime in Settings."
    private static let primaryButtonlabel: String = "Enable at Login"
    private static let secondaryButtonlabel: String = "Not Now"
    
    
    static func showLaunchAtLoginAlert(_ action: () -> Void) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: primaryButtonlabel)
        alert.addButton(withTitle: secondaryButtonlabel)
        
        let response = alert.runModal()
        
        switch response {
        case .alertFirstButtonReturn:
            action()
        default:
            break
        }
    }
}
