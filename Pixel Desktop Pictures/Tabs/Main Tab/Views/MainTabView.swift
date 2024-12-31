//
//  MainTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - PROPERTIES
    @State private var mainTabVM: MainTabViewModel = .init()
    @State private var boolean: Bool = true
    
    // MARK: - BODY
    var body: some View {
        Group {
            if boolean {
                VStack(spacing: 0) {
                    // Image Preview
                    ImageContainerView(
                        thumbnailURLString: CollectionVGridItemModel.defaultItemsArray.first!.imageURLString,
                        imageURLString: CollectionVGridItemModel.defaultItemsArray.first!.imageURLString,
                        location: "Colombo, Sri Lanka"
                    ) // change this later with a view model property model
                    
                    VStack {
                        // Set Desktop Picture Button
                        ButtonView(title: "Set Desktop Picture", type: .regular) { mainTabVM.setDesktopPicture() }
                        
                        // Author and Download Button
                        footer
                    }
                    .padding()
                }
                .onTapGesture {
                    boolean.toggle()
                }
            } else {
                ImagePreviewErrorView()
                    .onTapGesture {
                        boolean.toggle()
                    }
            }
        }
        .setTabContentHeightToTabsViewModelViewModifier
        .environment(mainTabVM)
    }
}

// MARK: - PREVIEWS
#Preview("Main Tab View") {
    PreviewView { MainTabView()  }
}

// MARK: - EXTENSIONS
extension MainTabView {
    // MARK: - Footer
    private var footer: some View {
        HStack {
            ImageAuthorView(name: "John Doe") // change this later with a view model property model
            Spacer()
            DownloadButtonView()
        }
        .padding(.top)
    }
}
