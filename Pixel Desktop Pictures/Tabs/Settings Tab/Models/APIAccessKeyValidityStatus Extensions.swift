//
//  APIAccessKeyValidityStatus Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUICore

/**
 An extension to `APIAccessKeyValidityStatus` that provides SwiftUI views and properties for displaying the status of an API access key.
 This extension includes:
 - A `View` for displaying the status text with appropriate styling.
 - A `View` for displaying a system image (SF Symbol) representing the status.
 - A computed property for determining the button title based on the status.
 This extension enhances the `APIAccessKeyValidityStatus` enum with UI-related functionality, making it easier to integrate into SwiftUI views.
 */
extension APIAccessKeyValidityStatus {
    var status: some View {
        switch self {
        case .notFound:
            return Text("Not Found")
                .foregroundStyle(.secondary)
        case .validating:
            return Text("Validating")
        case .connected, .rateLimited:
            return Text("Connected")
                .foregroundStyle(.green)
        case .invalid:
            return Text("Invalid Key")
                .foregroundStyle(.yellow)
        case .failed:
            return Text("Internet Connection Failure")
                .foregroundStyle(.red)
        }
    }
    
    @ViewBuilder
    var systemImage: some View {
        switch self {
        case .notFound:
            Image(systemName: "questionmark.key.filled")
                .symbolEffect(.pulse.wholeSymbol)
                .foregroundStyle(.secondary)
        case .validating:
            Image(systemName: "progress.indicator")
                .symbolEffect(.variableColor.iterative.hideInactiveLayers)
        case .connected, .rateLimited:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .invalid:
            Image(systemName: "key.slash.fill")
                .symbolEffect(.wiggle.byLayer)
                .foregroundStyle(.yellow)
        case .failed:
            Image(systemName: "wifi.exclamationmark")
                .foregroundStyle(.red)
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .notFound, .failed:
            return "Add Your API Access Key"
        case .validating, .connected, .rateLimited:
            return "API Access Key"
        case .invalid:
            return "Replace Your API Access Key"
        }
    }
}
