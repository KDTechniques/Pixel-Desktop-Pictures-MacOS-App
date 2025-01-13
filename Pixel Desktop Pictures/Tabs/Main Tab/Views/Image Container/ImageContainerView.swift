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
        .background(Color.debug)
        .overlay { centerButton }
        .overlay(alignment: .bottomLeading) { locationText }
    }
}

// MARK: - PREVIEWS
#Preview("Image Preview Image Container View") {
    @Previewable @State var thumbImageURLString: String = ""
    @Previewable @State var regularImageURLString: String = ""
    
    ImageContainerView(
        thumbnailURLString: thumbImageURLString,
        imageURLString: regularImageURLString,
        location: "Colombo, Sri Lanka"
    ) // change this later with a view model property model
    .task {
        thumbImageURLString = try! await CollectionModelManager.shared.getImageURLs(from: CollectionModel.getDefaultCollectionsArray().first!).thumb
        regularImageURLString = try! await CollectionModelManager.shared.getImageURLs(from: CollectionModel.getDefaultCollectionsArray().first!).regular
    }
    .previewModifier
}

// MARK: EXTENSIONS
extension ImageContainerView {
    // MARK: - Center Item
    private var centerButton: some View {
        ImageContainerOverlayCenterView(centerItem: mainTabVM.centerItem) {
            guard mainTabVM.centerItem == .retryIcon else { return }
            mainTabVM.nextImage()
        }
    }
    
    // MARK: - thumbnail
    private var thumbnail: some View {
        WebImage(
            url: .init(string: thumbnailURLString),
            options: [.retryFailed, .highPriority]
        )
        .placeholder { Color.clear }
    }
    
    // MARK: - Location Text
    private var locationText: some View {
        Label(location, systemImage: "location.fill")
            .foregroundStyle(.white)
            .font(.subheadline)
            .padding()
    }
}
