//
//  CollectionsTabVM+Read.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
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
            
            print("✅: All image api query images tasks have been completed. Results: \(queryImagesWithCollectionNamesArray)")
            
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
    
    /// Retrieves and sets the query images array based on selected collections.
    ///
    /// This function filters the selected collections, fetches the associated query images from the
    /// local database, and assigns the resulting array to `queryImagesArray`. Any errors encountered
    /// during the fetching process are logged.
    ///
    /// - Note: Only the selected collections are considered when fetching query images.
    /// - Throws: An error if fetching query images from the local database fails.
    func getAndSetQueryImagesArray() async throws {
        // Filter selected collection names.
        let selectedCollectionNamesArray: [String] = collectionsArray.filter({ $0.isSelected }).map({ $0.name })
        
        do {
            // Fetch `QueryImage` items for the selected collection names from the local database.
            let queryImagesArray: [QueryImage] = try await getQueryImageManager().fetchQueryImages(for: selectedCollectionNamesArray)
            setQueryImagesArray(queryImagesArray)
            print(queryImagesArray.isEmpty ? "⚠️: Fetched query images array found empty." : "✅: Query images array has been fetched successfully.")
        } catch {
            print(CollectionsViewModelError.failedSomethingOnQueryImages(error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedSomethingOnQueryImages)
            throw error
        }
    }
}
