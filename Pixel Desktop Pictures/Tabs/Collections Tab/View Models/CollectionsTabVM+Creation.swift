//
//  CollectionsTabVM+Creation.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

// Create Collections Related
extension CollectionsTabViewModel {
    /// Creates a new collection and updates related components.
    ///
    /// This function handles the creation of a new collection by capitalizing the collection name,
    /// preparing the necessary data (including image quality URL strings), and saving the collection
    /// to both the local database and the collections array. It also manages UI updates for success or failure.
    ///
    /// - Note: Ensures that the collection name is valid and prevents creation of collections with empty names.
    /// - Throws: An error if the collection creation process fails, including issues with preparing data or database operations.
    func createCollection() async {
        // Collection name capitalization for processing and saving to local database.
        let collectionName: String = nameTextfieldText.capitalized
        
        // Early exit to avoid errors when creating a collection with an empty value.
        guard await handleEmptyCollectionName(collectionName) else { return }
        
        do {
            // Handle query images and get encoded collection image quality url strings
            let imageQualityURLStringsEncoded: Data = try await prepareCollectionUpdate(
                name: collectionName,
                for: .onCollectionCreation
            )
            
            // Create the `Collection` item.
            let collectionItem: Collection = .init(
                name: collectionName,
                imageQualityURLStringsEncoded: imageQualityURLStringsEncoded
            )
            
            // First, add the new item to local database.
            try await getCollectionManager().addCollections([collectionItem])
            
            // Then, add the item to the collections array.
            appendCollectionsArray(collectionItem)
            
            // Handle successful creation.
            setShowCreateButtonProgress(false)
            presentPopup(false, for: .collectionCreationPopOver)
            print("✅: `\(collectionName)` collection has been created successfully.")
        } catch {
            setShowCreateButtonProgress(false)
            print(getVMError().failedToCreateCollection(collectionName: collectionName, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToCreateCollection)
            getAPIAccessKeyManager().handleURLError(error)
        }
    }
    
    /// Fetches query images for a list of collection names and adds them to the local database.
    ///
    /// This function fetches query images concurrently for each collection name using the Unsplash API,
    /// encodes the retrieved data, and saves the resulting `QueryImage` items to the local database.
    /// It uses a task group to handle concurrent fetching and handles any errors that occur during the process.
    ///
    /// - Parameter collectionNames: A list of collection names for which query images are fetched.
    /// - Throws: An error if any of the fetch or encoding operations fail, or if saving to the local database encounters an issue.
    func fetchAndAddInitialQueryImages(with collectionNames: [String]) async throws {
        do {
            // Create an image API service instance to fetch data for each `QueryImage` on collection name
            let imageAPIService: UnsplashImageAPIService = try await getImageAPIServiceInstance()
            
            // Using `withThrowingTaskGroup` for concurrency.
            let queryImagesWithCollectionNamesArray: [(String, UnsplashQueryImages)] = try await withThrowingTaskGroup(of: (String, UnsplashQueryImages).self) { taskGroup in
                for collectionName in collectionNames {
                    taskGroup.addTask { [weak self] in
                        // Fetch image api query images for each collection name.
                        do {
                            print("🤞: Fetching image api query images for \(collectionName)...")
                            let queryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(query: collectionName, pageNumber: 1)
                            print("✅: Successfully fetched image api query images for \(collectionName).")
                            return (collectionName, queryImages)
                        } catch {
                            await print(self?.getVMError().failedToFetchQueryImages(collectionName: collectionName, error).localizedDescription as Any)
                            throw error
                        }
                    }
                }
                
                // Collect results
                var tempQueryImagesArray: [(String, UnsplashQueryImages)] = []
                for try await result in taskGroup {
                    tempQueryImagesArray.append(result)
                }
                
                return tempQueryImagesArray
            }
            
            print("✅: All image api query images tasks have been completed. Results count: \(queryImagesWithCollectionNamesArray.count)")
            
            // Create `QueryImage` items once all image api query images tasks are completed.
            var tempQueryImagesArray: [QueryImage] = []
            let encoder: JSONEncoder = .init()
            
            for queryImage in queryImagesWithCollectionNamesArray {
                let queryImagesEncoded: Data = try encoder.encode(queryImage.1)
                let queryImageItem: QueryImage = .init(query: queryImage.0, queryImagesEncoded: queryImagesEncoded)
                tempQueryImagesArray.append(queryImageItem)
            }
            
            // Save created `QueryImage`s array to local database.
            try await getQueryImageManager().addQueryImages(tempQueryImagesArray)
            print("✅: Initial `QueryImage`s array has been created and saved successfully to local database.")
        } catch {
            print(getVMError().failedToFetchInitialQueryImages(collectionNames: collectionNames, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedSomethingOnQueryImages)
            throw error
        }
    }
}
