//
//  SettingsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

enum ImageUpdateIntervalTypes: String, CaseIterable {
    case hourly, daily, weekly
}

struct SettingsView: View {
    
    @State private var launchAtLogin: Bool = false
    @State private var showOnAllSpaces: Bool = false
    @State private var updateInterval: ImageUpdateIntervalTypes = .daily
    @State private var isPresentedPopup: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding()
            
            Text("Settings")
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .bottom])
            
            VStack(alignment: .leading) {
                // Launch at login checkbox
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(launchAtLogin ? Color.accentColor : Color.buttonBackground)
                        .frame(width: 12, height: 12)
                        .overlay {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8)
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                                .opacity(launchAtLogin ? 1 : 0)
                        }
                        .onTapGesture {
                            launchAtLogin.toggle()
                        }
                    
                    Text("Launch at login")
                }
                
                // Show on all spaces
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(showOnAllSpaces ? Color.accentColor : Color.buttonBackground)
                        .frame(width: 12, height: 12)
                        .overlay {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8)
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                                .opacity(showOnAllSpaces ? 1 : 0)
                        }
                        .onTapGesture {
                            showOnAllSpaces.toggle()
                        }
                    
                    Text("Show on all spaces")
                }
                
                // Update Time Interval
                Picker("Update", selection: $updateInterval) {
                    ForEach(ImageUpdateIntervalTypes.allCases, id: \.self) { interval in
                        Text(interval.rawValue.capitalized)
                    }
                }
                .frame(width: 132)
                
                Divider()
                    .padding(.vertical)
                
                let status: APIAccessKeyStatus = .connected
                
                VStack(alignment: .leading) {
                    // API Access key Status
                    HStack(spacing: 5) {
                        Text("API Access Key Staus:")
                        status.status
                        status.systemImage
                    }
                    
                    // API Key insertion
                    Button {
                        isPresentedPopup = true
                    } label: {
                        Text(status.buttonTitle)
                            .foregroundStyle(Color.buttonForeground)
                            .fontWeight(.medium)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
                }
                .padding(.bottom)
                
                // Restore Default settings, Version and Quit button
                VStack(alignment: .trailing, spacing: 5) {
                    Button {
                        // quir action goes here...
                    } label: {
                        Text("Restore Default Settings")
                            .foregroundStyle(Color.buttonForeground)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
                    }
                    .buttonStyle(.plain)
                    
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 2) {
                            if let version: String = Utilities.appVersion() {
                                Text("Version \(version) 🇱🇰")
                                Text("By **KAVINDA DILSHAN PARAMSOODI**")
                            }
                        }
                        .font(.footnote)
                        
                        Spacer()
                        
                        Button {
                            // quir action goes here...
                        } label: {
                            Text("Quit")
                                .foregroundStyle(Color.buttonForeground)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

#Preview("Settings View") {
    SettingsView()
        .frame(width: 375)
        .background(Color.windowBackground)
}


enum APIAccessKeyStatus {
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
            Image(systemName: "dot.radiowaves.left.and.right")
                .symbolEffect(.variableColor.iterative)
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
