//
//  CollectionsTabVM+Read.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
    func fetchNAddQueryImages(with collectionNames: [String]) async throws {
        // Create image API service instance to fetch data for each `QueryImage` on collection name
        guard let apiAccessKey: String = await getAPIAccessKeyManager().getAPIAccessKey() else { return }
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
        
        // Using withTaskGroup for concurrency
        let queryImagesWithCollectionNamesArray: [(String, UnsplashQueryImages)] = try await withThrowingTaskGroup(of: (String, UnsplashQueryImages).self) { taskGroup in
            for collectionName in collectionNames {
                taskGroup.addTask {
                    // Fetch data for each collection name
                    do {
                        print("Fetching data for \(collectionName)...")
                        let queryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(query: collectionName, pageNumber: 1)
                        print("Successfully fetched data for \(collectionName).")
                        return (collectionName, queryImages)
                    } catch {
                        print("Error: Failed fetch data for \(collectionName). \(error)")
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
        
        print("All tasks completed. Query results: \(queryImagesWithCollectionNamesArray)")
        
        // Create `QueryImage` item once all tasks are complete
        var queryImagesArray: [QueryImage] = []
        let encoder: JSONEncoder = .init()
        
        for queryImage in queryImagesWithCollectionNamesArray {
            do {
                let queryImagesEncoded: Data = try encoder.encode(queryImage.1)
                let queryImage: QueryImage = .init(query: queryImage.0, queryImagesEncoded: queryImagesEncoded)
                queryImagesArray.append(queryImage)
            } catch {
                print("Error: Failed to encode data for \(queryImage.0). \(error)")
                throw error
            }
        }
        
        // Save created `QueryImage` objects to swift data
        print("All tasks completed. Saving \(queryImagesArray.count) `QueryImage`s to local database...")
        try await getQueryImageManager().addQueryImages(queryImagesArray)
    }
    
    func getNSetQueryImagesArray() async {
        /// Filter the selected ones and get their names.
        /// Then pass them to the LocalDatabaseManager class to fetch an array of [QueryImage].
        /// Finally, assign the result to queryImagesArray.
        let selectedCollectionNamesArray: [String] = collectionsArray.filter({ $0.isSelected }).map({ $0.name })
        
        do {
            let queryImagesArray: [QueryImage] = try await getQueryImageManager().fetchQueryImages(for: selectedCollectionNamesArray)
            setQueryImagesArray(queryImagesArray)
        } catch {
            print("Error: Failed to set `ImageQueryURLModels` to an array. \(error.localizedDescription)")
        }
    }
}
