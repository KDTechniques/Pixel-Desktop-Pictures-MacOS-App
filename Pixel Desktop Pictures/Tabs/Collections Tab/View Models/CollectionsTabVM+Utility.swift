//
//  CollectionsTabVM+Utility.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import SwiftUICore

extension CollectionsTabViewModel {
    /// Initializes the Collections ViewModel by fetching collections and query images from the local database or creating default data.
    ///
    /// This function attempts to retrieve collections stored in the local database. If no collections are found,
    /// it creates a default set of collections and their associated `QueryImage` data, saves them to the database,
    /// and prepares the collections array for use. For subsequent launches, persistent data is used to initialize the view model.
    ///
    /// If an error occurs during initialization, the function falls back to setting default or empty collections,
    /// and displays an error popup.
    ///
    /// - Important: The function ensures that the `Collections Tab View Model` is initialized correctly with either
    /// persistent or default data to prevent the app from running in an inconsistent state.
    func initializeCollectionsViewModel() async {
        do {
            // Try to fetch collections from local database, if available.
            let fetchedCollectionsArray: [Collection] = try await getCollectionManager().getCollections()
            
            // Handle the case where no collections are found in local database.
            guard !fetchedCollectionsArray.isEmpty else {
                // Use the default values as the initial data or fallback option.
                let defaultCollectionsArray: [Collection] = try Collection.getDefaultCollectionsArray()
                
                // Omit the `RANDOM` collection, and map only collection names for processing
                let collectionNamesArray: [String] = defaultCollectionsArray
                    .filter { $0.name != Collection.randomKeywordString }
                    .map({ $0.name })
                
                // Fetch and add initial `QueryImage`s to local database
                try await fetchAndAddInitialQueryImages(with: collectionNamesArray)
                
                // Save the default collections array to local database.
                try await getCollectionManager().addCollections(defaultCollectionsArray)
                
                // Then prepare the collections array.
                setCollectionsArray(defaultCollectionsArray)
                Logger.log("✅: Initial default collections array has been added to local database")
                return
            }
            
            // After the initial launch, persistent data is available for use.
            setCollectionsArray(fetchedCollectionsArray)
            
            // Prepare query images array with selected collections fetched from the local database.
            try await getAndSetQueryImagesArray()
            
            Logger.log("✅: Collections has been fetched from the local database")
            Logger.log("✅: `Collections Tab View Model` has been initialized!")
        } catch {
            Logger.log(getVMError().failedToInitializeCollectionsTabVM(error).localizedDescription)
            
            do {
                let defaultCollectionsArray: [Collection] = try Collection.getDefaultCollectionsArray()
                setCollectionsArray(defaultCollectionsArray)
                Logger.log("⚠️: Default collections array has been added.")
            } catch {
                setCollectionsArray([]) // The window error will be taken care of from view level
                Logger.log("⚠️: Empty collections array has been assigned.")
            }
            
            await getErrorPopupVM().addError(getErrorPopup().somethingWentWrong)
        }
    }
    
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
