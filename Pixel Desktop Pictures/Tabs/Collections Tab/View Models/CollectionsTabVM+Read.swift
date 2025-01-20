//
//  CollectionsTabVM+Read.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
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
