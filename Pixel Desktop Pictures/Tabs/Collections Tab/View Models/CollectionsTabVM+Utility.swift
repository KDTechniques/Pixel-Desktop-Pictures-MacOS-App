//
//  CollectionsTabVM+Utility.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import SwiftUI

extension CollectionsTabViewModel {
    /// Presents or dismisses a popup with a smooth animation and resets related components when dismissed.
    ///
    /// This function animates the display of a popup by updating its presentation state and type.
    /// When the popup is dismissed, it resets associated components such as text fields and the updating item.
    /// A slight delay is added to ensure the reset occurs after the popup's dismissal animation completes.
    ///
    /// - Parameters:
    ///   - isPresented: A Boolean indicating whether the popup should be presented (`true`) or dismissed (`false`).
    ///   - type: The type of the popup, represented by `CollectionsViewPopOver`.
    func presentPopup(_ isPresented: Bool, for type: CollectionsViewPopOver) {
        withAnimation(TabItem.bottomPopupAnimation) {
            setPopOverItem((isPresented, type))
        }
        
        // If popup is dismissed, clear and reset related components.
        guard !isPresented else { return }
        resetTextfieldTexts()
        Task {
            // Adds one millisecond to popup animation duration to reset once the popup dismisses properly.
            try? await Task.sleep(nanoseconds: 400_000_000)
            resetUpdatingItem()
        }
        Logger.log("✅: Bottom popup has been presented/dismissed.")
    }
    
    /// Handles the scroll position when the collection items array changes.
    ///
    /// This function ensures the scroll position moves to the bottom edge when new items are added
    /// to the collection array. The scroll animation is triggered only if the array previously had
    /// at least one item and the new value indicates an increase in the number of items.
    ///
    /// - Parameters:
    ///   - oldValue: The previous number of items in the collection array.
    ///   - newValue: The current number of items in the collection array.
    ///   - scrollPosition: A binding to the scroll position, used to update its value dynamically.
    func onCollectionItemsArrayChange(oldValue: Int, newValue: Int, scrollPosition: Binding<ScrollPosition>) {
        guard oldValue != 0, oldValue < newValue else { return }
        withAnimation {
            scrollPosition.wrappedValue.scrollTo(edge: .bottom)
        }
        Logger.log("✅: Scroll position has been animated on collection items array change.")
    }
    
    /// Retrieves an instance of `UnsplashImageAPIService` configured with the API access key.
    ///
    /// This function fetches the API access key from the `APIAccessKeyManager` and uses it to initialize
    /// an instance of `UnsplashImageAPIService`. If the API access key is not available, an error is thrown.
    ///
    /// - Returns: A configured instance of `UnsplashImageAPIService`.
    /// - Throws: An error if the API access key is not found.
    func getImageAPIServiceInstance() async throws -> UnsplashImageAPIService {
        guard let apiAccessKey: String = await getAPIAccessKeyManager().getAPIAccessKey() else {
            Logger.log(getVMError().apiAccessKeyNotFound.localizedDescription)
            throw getVMError().apiAccessKeyNotFound
        }
        
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
        
        Logger.log("✅: Image api instance has been returned.")
        return imageAPIService
    }
}
