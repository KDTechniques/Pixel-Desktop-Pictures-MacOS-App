//
//  AlertsModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-30.
//

import SwiftUI

struct AlertsModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let message: String?
    let primaryButton: Alert.Button
    let secondaryButton: Alert.Button?
}
