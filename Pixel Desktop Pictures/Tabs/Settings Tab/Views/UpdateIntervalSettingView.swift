//
//  UpdateIntervalSettingView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct UpdateIntervalSettingView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    
    // MARK: - BODY
    var body: some View {
        Picker("Update", selection: settingsTabVM.binding(\.updateIntervalSelection)) {
            ForEach(DesktopPictureSchedulerInterval.allCases, id: \.self) { interval in
                Text(interval.timeIntervalName)
            }
        }
        .frame(width: 132) 
    }
}

// MARK: - PREVIEWS
#Preview("Update Interval Setting View") {
    UpdateIntervalSettingView()
        .padding()
        .previewModifier
}
