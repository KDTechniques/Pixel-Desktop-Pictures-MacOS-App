//
//  CollectionsVGridImageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI
import SDWebImageSwiftUI


struct VGridItemWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CollectionsVGridImageView: View {
    // MARK: - INJECTED PROPERTIES
    let item: CollectionModel
    
    // MARK: - ASSIGNED PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var showEditButton: Bool = false
    
    // MARK: - INITIALIZER
    init(item: CollectionModel) {
        self.item = item
    }
    
    // MARK: - PRIVATE PROPERTIES
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let imageURLString: String = try? item.getImageURLs().small {
                WebImage(
                    url: .init(string: imageURLString),
                    options: [.retryFailed, .continueInBackground, .highPriority, .scaleDownLargeImages]
                )
                .placeholder {
                    if item.collectionName != CollectionModel.randomKeywordString {
                        ProgressView().scaleEffect(0.3)
                    }
                }
                .resizable()
                .scaledToFill()
            } else {
                Color.clear
            }
        }
        .frame(width: vGridValues.width, height: vGridValues.height)
        .clipped()
        .overlay(Color.vGridItemOverlay)
        .overlay { overlay }
        .onHover { handleHover($0) }
        .onTapGesture { handleTap() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Image View") {
    CollectionsVGridImageView(item: try! .getDefaultCollectionsArray()[3])
        .frame(width: 120)
        .padding()
        .environment(
            CollectionsViewModel(
                apiAccessKeyManager: .init(),
                swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)))
        )
        .previewModifier
}

// MARK: EXTENSIONS
extension CollectionsVGridImageView {
    // MARK: - Checkmark
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.subheadline.bold())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(6)
            .opacity(item.isSelected ? 1 : 0)
    }
    
    // MARK: - Edit Button
    private var editButton: some View {
        Button {
            Task {
                collectionsVM.updatingItem = item
                collectionsVM.presentPopup(true, for: .collectionUpdatePopOver)
            }
        } label: {
            Image(systemName: "applepencil.gen1")
                .font(.subheadline)
                .fontWeight(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(6)
        }
        .opacity(item.isEditable ? 1 : 0)
        .opacity(showEditButton ? 1 : 0)
        .buttonStyle(.plain)
        .disabled(!item.isEditable)
    }
    
    // MARK: - Overlay
    private var overlay: some View {
        Group {
            checkmark
            CollectionNameOverlayView(collectionName: item.collectionName)
            editButton
        }
        .foregroundStyle(.white)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle Tap
    private func handleTap() {
        collectionsVM.handleCollectionItemTap(item: item)
    }
    
    // MARK: - Handle Hover
    private func handleHover(_ isHovering: Bool) {
        withAnimation(.smooth(duration: 0.3)) {
            showEditButton = isHovering
        }
    }
}
