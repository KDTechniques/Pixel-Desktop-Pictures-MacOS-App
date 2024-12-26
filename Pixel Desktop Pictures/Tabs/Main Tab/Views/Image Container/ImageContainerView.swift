//
//  ImageContainerView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageContainerView: View {
    // MARK: - PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    let thumbnailURLString: String
    let imageURLString: String
    let location: String
    
    // MARK: - PRIVATE PROPERTIES
    @State private var centerItem: ImageContainerCenterItems = .random() // set to progress later as default value
    let imageHeight: CGFloat = 200
    
    // MARK: - INITIALIZER
    init(thumbnailURLString: String, imageURLString: String, location: String) {
        self.thumbnailURLString = thumbnailURLString
        self.imageURLString = imageURLString
        self.location = location
    }
    
    // MARK: - BODY
    var body: some View {
        WebImage(
            url: .init(string: imageURLString),
            options: [.retryFailed, .continueInBackground, .lowPriority, .scaleDownLargeImages]
        )
        .placeholder { thumbnail }
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity)
        .frame(height: imageHeight)
        .clipped()
        .overlay { centerButton }
        .overlay(alignment: .bottomLeading) { locationText }
    }
}

// MARK: - PREVIEWS
#Preview("Image Preview Image Container View") {
    ImageContainerView(
        thumbnailURLString: CollectionVGridItemModel.defaultItemsArray.first!.imageURLString,
        imageURLString: CollectionVGridItemModel.defaultItemsArray.first!.imageURLString,
        location: "Playa Mixota, Spain"
    )
    .frame(width: TabItems.allWindowWidth)
    .background(Color.windowBackground)
    .environment(TabsViewModel())
}

// MARK: - EXTENSIONS
extension ImageContainerView {
    // MARK: - Center Item
    private var centerButton: some View {
        ImageContainerOverlayCenterView(centerItem: centerItem) {
            guard centerItem == .retryIcon else { return }
            mainTabVM.nextImage()
        }
    }
    
    // MARK: - thumbnail
    private var thumbnail: some View {
        WebImage(
            url: .init(string: thumbnailURLString),
            options: [.retryFailed, .highPriority]
        )
        .placeholder { thumbnailPlaceholder }
    }
    
    // MARK: - Thumbnail Placeholder
    private var thumbnailPlaceholder: some View {
        Rectangle()
            .fill(.primary.opacity(0.1))
            .frame(height: imageHeight)
    }
    
    // MARK: - Location Text
    private var locationText: some View {
        Label(location, systemImage: "location.fill")
            .foregroundStyle(.white)
            .font(.subheadline)
            .padding()
    }
}
