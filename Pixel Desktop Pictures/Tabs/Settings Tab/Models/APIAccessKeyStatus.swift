//
//  APIAccessKeyStatus.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUICore

enum APIAccessKeyStatus: CaseIterable {
    case validating, connected, invalid, failed
    
    var status: some View {
        switch self {
        case .validating:
            return Text("Validating")
        case .connected:
            return Text("Connected")
                .foregroundStyle(.green)
        case .invalid:
            return Text("Invalid")
                .foregroundStyle(.secondary)
        case .failed:
            return Text("Internet Connection Failure")
                .foregroundStyle(.red)
        }
    }
    
    @ViewBuilder
    var systemImage: some View {
        switch self {
        case .validating:
            Image(systemName: "progress.indicator")
                .symbolEffect(.variableColor.iterative.hideInactiveLayers)
        case .connected:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .invalid:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
        case .failed:
            Image(systemName: "wifi.exclamationmark")
                .foregroundStyle(.red)
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .validating, .connected:
            return "API Access Key"
        case .invalid:
            return "Replace Your API Access Key"
        case .failed:
            return "Add Your API Access Key"
        }
    }
}
