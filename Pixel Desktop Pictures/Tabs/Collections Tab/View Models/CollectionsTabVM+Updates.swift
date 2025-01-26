//
//  CollectionsTabVM+Updates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

extension CollectionsTabViewModel {
    /// Renames a collection in the local database and updates associated components.
    ///
    /// This function validates the new collection name, updates the collection in the local database,
    /// and handles any errors or UI updates related to the renaming process.
    ///
    /// - Note: Interacts with the Collection Manager, Error Popup ViewModel, and API Access Key Manager.
    func renameCollection() async {
        // Collection name capitalization for processing and saving to local database.
        let newCollectionName: String = renameTextfieldText.capitalized
        
        // Exit early if the updating item is nil.
        guard let updatingCollectionItem: Collection = updatingItem else {
            print(getVMError().updatingItemFoundNil.localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().somethingWentWrong)
            return
        }
        
        // Early exit to avoid errors when creating a collection with empty name.
        guard await handleEmptyCollectionName(newCollectionName) else { return }
        
        do {
            // Handle query images and get encoded collection image quality url strings
            let imageQualityURLStringsEncoded: Data = try await prepareCollectionUpdate(
                name: newCollectionName,
                for: .onCollectionRenaming
            )
            
            // Update collection name in local database.
            try await getCollectionManager().rename(
                for: updatingCollectionItem,
                newName: newCollectionName,
                imageQualityURLStringsEncoded: imageQualityURLStringsEncoded
            )
            
            // Handle success renaming.
            setShowRenameButtonProgress(false)
            resetTextfieldTexts()
            try await getAndSetQueryImagesArray()
            print("✅: Collection has been renamed to `\(newCollectionName)` successfully.")
        } catch {
            setShowRenameButtonProgress(false)
            print(getVMError().failedToRenameCollection(error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionName(error))
            getAPIAccessKeyManager().handleURLError(error)
        }
    }
    
    /// Updates the thumbnail image for a specified collection.
    ///
    /// This function fetches new query images using the Unsplash API service,
    /// updates the image quality URL strings for the collection in the local database,
    /// and handles any errors or UI updates during the process.
    ///
    /// - Parameter item: The collection for which the thumbnail image is being updated.
    func changeCollectionThumbnailImage(item: Collection) async {
        setShowChangeThumbnailButtonProgress(true)
        
        do {
            // Create an instance of image API service to fetch new image api query images for the desired collection.
            let imageAPIService: UnsplashImageAPIService = try await getImageAPIServiceInstance()
            
            // update new image quality url strings of the collection and save to local database.
            try await getCollectionManager().updateImageQualityURLStrings(for: item, imageAPIService: imageAPIService)
            
            // Handle successful image update
            setShowChangeThumbnailButtonProgress(false)
            print("✅: Thumbnail image has been updated successfully.")
        } catch {
            setShowChangeThumbnailButtonProgress(false)
            print(getVMError().failedToUpdateCollectionThumbnailImage(collectionName: item.name, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionThumbnailImage)
            getAPIAccessKeyManager().handleURLError(error)
        }
    }
    
    /// Updates the selection state of a collection and manages the random collection selection logic.
    ///
    /// This function handles toggling the selection state of a specified collection while ensuring
    /// the "random" collection is appropriately managed. If no collections are selected, the random
    /// collection is selected by default. Additionally, it updates the query images array to reflect
    /// the current selection.
    ///
    /// - Parameter item: The collection whose selection state needs to be updated.
    func updateCollectionSelection(item: Collection) async {
        let randomCollectionName: String = Collection.randomKeywordString
        
        do {
            // Handle the random collection selection case
            if item.name == randomCollectionName {
                // Deselect all the collections except the random collection.
                for collection in collectionsArray {
                    collection.name != randomCollectionName ? try await getCollectionManager().updateSelection(for: collection, with: false) : ()
                }
                
                // Then select the random collection only.
                try await getCollectionManager().updateSelection(for: item, with: true)
            } else {
                // Handle any collection selection case except the random collection
                
                // Toggle the tapped item's selection state
                try await getCollectionManager().updateSelection(for: item, with: !item.isSelected)
                
                // Ensure the random collection is selected, if no other collection is selected
                let isAllCollectionsDeselected: Bool = !collectionsArray.contains(where: { $0.isSelected })
                guard let randomCollection: Collection = collectionsArray.first(where: { $0.name == randomCollectionName }) else { return }
                try await getCollectionManager().updateSelection(for: randomCollection, with: isAllCollectionsDeselected)
            }
            
            // Update the query images array
            try await getAndSetQueryImagesArray()
            print("✅: Collection selection has been updated successfully.")
        } catch {
            print(getVMError().failedToUpdateCollectionSelection(collectionName: item.name, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionSelection)
        }
    }
    
    /// Updates the selection status of collections, excluding a specified collection.
    ///
    /// This function ensures that all collections, except the one specified in `excludedItem`,
    /// have their selection status set to false. The excluded collection retains its current
    /// selection status, and the query images array is updated accordingly. If the excluded
    /// item is the `RANDOM` collection, the function exits early without making any changes.
    ///
    /// - Parameter excludedItem: The `Collection` instance to exclude from the selection update.
    /// - Throws: Propagates errors that occur while updating the collection selections or
    ///           setting the query images array.
    func updateCollectionSelections(excludedItem: Collection) async {
        // Exit early if the excluded item is the `RANDOM` collection
        guard excludedItem.name != Collection.randomKeywordString else { return }
        
        // Filter all the collections except the excluded item.
        let collectionItems: [Collection] = collectionsArray.filter({ $0.name != excludedItem.name })
        
        do {
            // Set selection to false for filtered collections, and true for the excluded item.
            try await getCollectionManager().updateSelection(for: collectionItems, except: excludedItem)
            
            // Then set the query images array.
            try await getAndSetQueryImagesArray()
            print("✅: Collection selections has been updated to false successfully, except `\(excludedItem.name)` collection.")
        } catch {
            print(getVMError().failedToUpdateCollectionSelections(collectionName: excludedItem.name, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionSelection)
        }
    }
    
    /// Prepares the data required to update or create a collection.
    ///
    /// This function ensures the uniqueness of the collection name in the local database,
    /// fetches query images from the Unsplash API, and handles the creation or update of
    /// related database entries. It encodes the image quality URL strings into data for saving.
    ///
    /// - Parameters:
    ///   - name: The name of the collection to be created or updated.
    ///   - usage: The context in which the function is being used, such as for collection creation or renaming.
    /// - Returns: Encoded `Data` containing the image quality URL strings for the collection.
    /// - Throws: An error if the collection name is duplicated, API service fails, or encoding fails.
    func prepareCollectionUpdate(name: String, for usage: CollectionNameUsage) async throws -> Data {
        do {
            // Since the collection name must be unique in the local database, duplication must be avoided.
            try await checkCollectionNameDuplications(name)
            
            // Present relevant progress
            switch usage {
            case .onCollectionCreation:
                setShowCreateButtonProgress(true)
            case .onCollectionRenaming:
                setShowRenameButtonProgress(true)
            }
            
            // Create image api service instance to fetch data for the given collection name
            let imageAPIService: UnsplashImageAPIService = try await getImageAPIServiceInstance()
            
            // Avoid updating existing data with initial values when `QueryImage` item is already exit.
            let isQueryImageExist: Bool = try await isQueryImageExistInLocalDatabase(for: name)
            
            // A collection requires only one query image item to work with.
            let queryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(
                query: name,
                pageNumber: 1,
                imagesPerPage: UnsplashImageAPIService.imagesPerPage
            )
            
            // Early exit if the the fetched results array count is less than 2 and empty.
            guard !queryImages.results.isEmpty, queryImages.results.count > 1  else {
                throw URLError(.resourceUnavailable)
            }
            
            // Handle when there's no saved `QueryImage` item for the given collection name in the local database.
            if !isQueryImageExist {
                // Create the `QueryImage` item relevant to the given collection name.
                let queryImagesEncoded: Data = try getJSONEncoder().encode(queryImages)
                let queryImageItem: QueryImage = .init(query: name, queryImagesEncoded: queryImagesEncoded)
                
                // Save the `QueryImage` item to local database.
                try await getQueryImageManager().addQueryImages([queryImageItem])
            }
            
            // Get the first `imageQualityURLStrings` from the image api query image result for the collection.
            guard let imageQualityURLStrings: UnsplashImageResolution = queryImages.results.first?.imageQualityURLStrings else {
                throw URLError(.badServerResponse)
            }
            
            // Encode the `imageQualityURLStrings` to data.
            let imageQualityURLStringsEncoded: Data = try getJSONEncoder().encode(imageQualityURLStrings)
            
            // Return encoded `imageQualityURLStrings` data for saving.
            print("✅: Collection update has been prepared successfully.")
            return imageQualityURLStringsEncoded
        } catch {
            print(getVMError().failedToPrepareCollectionUpdate(for: usage, error).localizedDescription)
            throw error
        }
    }
}
