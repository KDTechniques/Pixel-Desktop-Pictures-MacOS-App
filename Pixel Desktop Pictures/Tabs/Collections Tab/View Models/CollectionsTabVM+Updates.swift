//
//  CollectionsTabVM+Updates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

extension CollectionsTabViewModel {
    func renameCollection() {
        Task {
            // Collection name capitalization for processing and saving to local database.
            let newCollectionName: String = renameTextfieldText.capitalized
            
            // Exit early if the updating item is nil.
            guard let updatingCollectionItem: Collection = updatingItem else {
                await getErrorPopupVM().addError(getErrorPopup().somethingWentWrong)
                print("Error: Updating item is nil.")
                return
            }
            
            // Early exit to avoid errors when creating a collection with an empty value.
            guard await handleEmptyCollectionName(newCollectionName) else { return }
            
            do {
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
                
                // Handle success update.
                setShowRenameButtonProgress(false)
                resetTextfieldTexts()
                await getNSetQueryImagesArray()
            } catch {
                setShowRenameButtonProgress(false)
                await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionName)
                getAPIAccessKeyManager().handleURLError(error)
                print("Error: Failed to update collection name. \(error.localizedDescription)")
            }
        }
    }
    
    func updateCollectionImageURLString(item: Collection) async {
        setShowChangeThumbnailButtonProgress(true)
        
        do {
            // Create an instance of image API service to fetch new query images for the desired collection.
            let imageAPIService: UnsplashImageAPIService = try await getImageAPIServiceInstance()
            
            // update new image quality url strings of the collection and save to local database.
            try await getCollectionManager().updateImageQualityURLStrings(for: item, imageAPIService: imageAPIService)
            
            // Handle success
            setShowChangeThumbnailButtonProgress(false)
        } catch {
            setShowChangeThumbnailButtonProgress(false)
            await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionThumbnail)
            getAPIAccessKeyManager().handleURLError(error)
            print("Error: Failed to update collection thumbnail. \(error.localizedDescription)")
        }
    }
    
    func updateCollectionSelection(item: Collection) async {
        let randomCollectionName: String = Collection.randomKeywordString
        
        do {
            // Handle the random collection selection case
            if item.name == randomCollectionName {
                for item in collectionsArray {
                    try await getCollectionManager().updateSelection(for: item, with: false)
                }
                
                try await getCollectionManager().updateSelection(for: item, with: !item.isSelected)
            } else {
                // Handle the other collection selection case
                
                // Toggle the tapped item's selection state
                try await getCollectionManager().updateSelection(for: item, with: !item.isSelected)
                
                // Ensure the random collection is deselected if no other collection is selected
                guard let randomCollection: Collection = collectionsArray.first(where: { $0.name == randomCollectionName }) else { return }
                try await getCollectionManager().updateSelection(for: randomCollection, with: !collectionsArray.contains(where: { $0.isSelected }))
            }
            
            // Update the query images array
            await getNSetQueryImagesArray()
        } catch {
            Task { await getErrorPopupVM().addError(getErrorPopup().failedToUpdateCollectionSelection) }
            print("Error: Failed to update collection selection. \(error.localizedDescription)")
        }
    }
    
    func prepareCollectionUpdate(name: String, for usage: CollectionNameUsage) async throws -> Data {
        // Since the collection name must be unique in the local database, duplication must be avoided.
        try await checkCollectionNameDuplications(name)
        
        // Present Progress
        switch usage {
        case .onCollectionCreation:
            setShowCreateButtonProgress(true)
        case .onCollectionRenaming:
            setShowRenameButtonProgress(true)
        }
        
        // Create image API service instance to fetch data for the given collection name
        let imageAPIService: UnsplashImageAPIService = try await getImageAPIServiceInstance()
        
        // Check whether the query image exist or not to avoid updating existing data with initial values.
        let isQueryImageExist: Bool = try await isQueryImageExistInLocalDatabase(for: name)
        
        // A collection requires only one query image item to work with.
        let queryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(
            query: name,
            pageNumber: 1,
            imagesPerPage: isQueryImageExist ? 1 : UnsplashImageAPIService.imagesPerPage
        )
        
        // Handle the case there's no saved query image for the given collection name
        if !isQueryImageExist {
            // Create the `QueryImage` item relevant to the given collection name.
            let queryImagesEncoded: Data = try getJSONEncoder().encode(queryImages)
            let queryImageItem: QueryImage = .init(query: name, queryImagesEncoded: queryImagesEncoded)
            
            // Save the `QueryImage` item to local database
            try await getQueryImageManager().addQueryImages([queryImageItem])
        }
        
        // Get the first result for the collection, and encode it to return.
        guard let imageQualityURLStrings: UnsplashImage = queryImages.results.first?.imageQualityURLStrings else {
            throw URLError(.badServerResponse)
        }
        
        let imageQualityURLStringsEncoded: Data = try getJSONEncoder().encode(imageQualityURLStrings)
        
        return imageQualityURLStringsEncoded
    }
}
