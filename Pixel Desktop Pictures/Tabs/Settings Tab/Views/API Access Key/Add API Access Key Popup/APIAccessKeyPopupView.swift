//
//  APIAccessKeyPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct APIAccessKeyPopupViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct APIAccessKeyPopupView: View {
    // MARK: - PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    
    // MARK: - PRIVATE PROPERTIES
    @State private var height: CGFloat = 0
    let dismissButtonFrameHeight: CGFloat = 30
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                // Textfield
                APIAccessKeyTextfieldView()
                
                // Connect Button
                ButtonView(title: "Connect", type: .popup) { settingsTabVM.connectAPIAccessKey() }
                    .disabled(settingsTabVM.apiAccessKeyTextfieldText.isEmpty ? true : false)
                
                // Instructions Container
                APIAccessKeyInstructionsView()
                    .padding(.top)
            }
            .padding([.horizontal, .bottom])
            .background(Color.popupBackground)
        }
        .padding(.top, dismissButtonFrameHeight)
        .overlay(alignment: .topTrailing) { dismissButton }
        .background {
            GeometryReader { geo in
                Color.popupBackground
                    .preference(key: APIAccessKeyPopupViewPreferenceKey.self, value: geo.size.height)
            }
            .onPreferenceChange(APIAccessKeyPopupViewPreferenceKey.self) { value in
                height = value
            }
        }
        .offset(y: settingsTabVM.isPresentedPopup ? 0 : height)
        .animation(.smooth(duration: 0.3), value: settingsTabVM.isPresentedPopup)
    }
}

// MARK: - PREVIEWS
#Preview("API Access Key Popup View") {
    APIAccessKeyPopupView()
        .frame(width: TabItemsModel.allWindowWidth)
        .environment(SettingsTabViewModel())
}

// MARK: - EXTENSIONS
extension APIAccessKeyPopupView {
    // MARK: - Dismiss Button
    private var dismissButton: some View {
        Button {
            settingsTabVM.presentPopup(false)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .font(.title2)
                .padding(5)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: dismissButtonFrameHeight, alignment: .top)
        .background(Color.popupBackground)
    }
}
