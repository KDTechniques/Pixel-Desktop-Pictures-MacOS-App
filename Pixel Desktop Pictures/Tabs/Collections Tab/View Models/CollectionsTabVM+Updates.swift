//
//  CollectionsTabVM+Updates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

extension CollectionsTabViewModel {
    func updateCollectionName() {
        Task {
            // Check updating item before proceeding.
            let newCollectionName: String = renameTextfieldText.capitalized
            guard !newCollectionName.isEmpty,
                  let updatingCollectionItem: Collection = updatingItem else {
                await getErrorPopupVM().addError(getErrorPopup().somethingWentWrong)
                print("Error: Either collection name or updating item is nil.")
                return
            }
            
            do {
                // To avoid updating collection names to already exist one.
                try await checkCollectionNameDuplications(newCollectionName)
                setShowRenameButtonProgress(true)
                
                // Create instance of image API service to fetch new data according to new collection name.
                guard let apiAccessKey: String = await getAPIAccessKeyManager().getAPIAccessKey() else { return }
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                
                if try await getQueryImageManager().fetchQueryImages(for: [newCollectionName]).isEmpty {
                    // Fetch query image from Unsplash api service and encode it.
                    let queryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(query: newCollectionName, pageNumber: 1)
                    let queryImagesEncoded: Data = try getJSONEncoder().encode(queryImages)
                    
                    // Create new query image item and save to local database.
                    let queryImageItem: QueryImage = .init(query: newCollectionName, queryImagesEncoded: queryImagesEncoded)
                    try await getQueryImageManager().addQueryImages([queryImageItem])
                }
                
                // Update collection name in local database.
                try await getCollectionManager().rename(for: updatingCollectionItem, newName: newCollectionName, imageAPIService: imageAPIService)
                
                // Handle success update.
                setShowRenameButtonProgress(false)
                resetTextfieldTexts()
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
            guard let apiAccessKey: String = await getAPIAccessKeyManager().getAPIAccessKey() else { return }
            let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
            
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
    
}
