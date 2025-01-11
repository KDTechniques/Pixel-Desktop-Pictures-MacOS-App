//
//  ContentNotAvailableModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-04.
//

import SwiftUI

enum ContentNotAvailableModel: CaseIterable {
    case apiAccessKeyNotFound
    case noInternetConnection
    case apiAccessKeyError
    case updatingCollectionItemNotFound
    case rateLimited
    
    var title: String {
        switch self {
        case .apiAccessKeyNotFound:
            return "API Access Key Not Found"
        case .noInternetConnection, .apiAccessKeyError:
            return "Failed to Fetch Content"
        case .updatingCollectionItemNotFound:
            return "You May Be Unable to Edit the Collection"
        case .rateLimited:
            return "Exceeded the Number of Image Changes"
        }
    }
    
    func description(action: @escaping () async -> Void) -> some View {
        Group {
            switch self {
            case .apiAccessKeyNotFound: apiAccessKeyNotFoundView { await action() }
            case .noInternetConnection: noInternetConnectionView
            case .apiAccessKeyError: apiAccessKeyErrorView { await action() }
            case .updatingCollectionItemNotFound: unableToEditCollectionView
            case .rateLimited: rateLimitedView { await action() }
            }
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: EXTENSIONS
fileprivate extension ContentNotAvailableModel {
    // MARK: - API Access Key Not Found View
    private func apiAccessKeyNotFoundView(_ action: @escaping () async -> Void) -> some View {
        HStack(spacing: 4) {
            Text("Go to")
            
            Button {
                Task { await action() }
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .foregroundStyle(Color.accentColor)
                .underline()
            }
            .buttonStyle(.plain)
            
            Text("tab to add one.")
        }
        .foregroundStyle(.secondary)
    }
    
    // MARK: - No Internet Connection View
    private var noInternetConnectionView: some View {
        Text("Make sure the Mac is connected to the internet.")
            .foregroundStyle(.secondary)
    }
    
    // MARK: - API Access Key Error View
    private func apiAccessKeyErrorView(_ action: @escaping () async -> Void) -> some View {
        VStack(spacing: 30) {
            Text("Your API access key is invalid. Please retry or add a new API access key.")
            ButtonView(title: "Retry", type: .regular) { Task { await action() } }
        }
    }
    
    // MARK: - Unable to Edit Collection View
    private var unableToEditCollectionView: some View {
        Text("Something went wrong! Please try again later.")
            .foregroundStyle(.secondary)
    }
    
    // MARK: - Rate Limited View
    private func rateLimitedView(_ action: @escaping () async -> Void) -> some View {
        VStack(spacing: 30) {
            Text("Too many changes in a short period. Please wait an hour before retrying.")
            ButtonView(title: "Retry", type: .regular) { Task { await action() } }
        }
    }
}
