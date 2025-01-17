//
//  CollectionsTabVM+Creation.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

// Create Collections Related
extension CollectionsTabViewModel {
    func createCollection() {
        // Assign the collection name to a temporary property in case it changes before this function finishes.
        let collectionName: String = nameTextfieldText.capitalized
        
        // Early exit to avoid errors when creating a collection with an empty value.
        guard !collectionName.isEmpty else { return }
        
        Task {
            do {
                // Since the collection name must be unique in the local database, duplication must be avoided.
                try await checkCollectionNameDuplications(collectionName)
                setShowCreateButtonProgress(true)
                
                // Create image API service instance to fetch data for the new collection
                guard let apiAccessKey: String = await getAPIAccessKeyManager().getAPIAccessKey() else { return }
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                
                // Check whether the query image exist or not to avoid updating existing data with initial values.
                let isQueryImageExist: Bool = try await !getQueryImageManager().fetchQueryImages(for: [collectionName]).isEmpty
            
                // Collection creation requires only one query image item to work with.
                let queryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(
                    query: collectionName,
                    pageNumber: 1,
                    imagesPerPage: isQueryImageExist ? 1 : UnsplashImageAPIService.imagesPerPage
                )
                
                // Get the first result, as there are more results.
                guard let imageQualityURLStrings: UnsplashImage = queryImages.results.first?.imageQualityURLStrings else {
                    throw URLError(.badServerResponse)
                }
                
                // Create the `Collection` item.
                let imageQualityURLStringsEncoded: Data = try getJSONEncoder().encode(imageQualityURLStrings)
                let collectionItem: Collection = .init(name: collectionName, imageQualityURLStringsEncoded: imageQualityURLStringsEncoded)
                
                if !isQueryImageExist {
                    // Create the `QueryImage` item relevant to the collection name.
                    let queryImagesEncoded: Data = try getJSONEncoder().encode(queryImages)
                    let queryImageItem: QueryImage = .init(query: collectionName, queryImagesEncoded: queryImagesEncoded)
                    
                    // Save the `QueryImage` item to local database
                    try await getQueryImageManager().addQueryImages([queryImageItem])
                }
                
                // First, add the new item to local database for better UX.
                try await getCollectionManager().addCollections([collectionItem])
                
                // Then, add the item to the collections array for the user to interact with.
                var tempCollectionsArray: [Collection] = collectionsArray
                tempCollectionsArray.append(collectionItem)
                setCollectionsArray(tempCollectionsArray)
                
                // Dismiss progress and popup after successful collection creation.
                setShowCreateButtonProgress(false)
                presentPopup(false, for: .collectionCreationPopOver)
            } catch {
                setShowCreateButtonProgress(false)
                await getErrorPopupVM().addError(getErrorPopup().failedToCreateCollection)
                getAPIAccessKeyManager().handleURLError(error)
                print("Error: Failed to create collection. \(error.localizedDescription)")
            }
        }
    }
}
