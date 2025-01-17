//
//  CollectionsTabVM+Utility.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import SwiftUICore

extension CollectionsTabViewModel {
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
                try await fetchNAddQueryImages(with: collectionNamesArray)
                
                // Save the default collections array to local database.
                try await getCollectionManager().addCollections(defaultCollectionsArray)
                
                // Then prepare the collections array.
                setCollectionsArray(defaultCollectionsArray)
                
                return
            }
            
            // After the initial launch, SwiftData is available for use.
            setCollectionsArray(fetchedCollectionsArray)
            print("`Collections Tab View Model` has been initialized!")
        } catch {
            print("Error: Failed to initialize `Collections View Model`: \(error.localizedDescription)")
            
            do {
                let defaultCollectionsArray: [Collection] = try Collection.getDefaultCollectionsArray()
                setCollectionsArray(defaultCollectionsArray)
            } catch {
                setCollectionsArray([]) // The window error will be taken care of from view level
            }
        }
    }
    
    func presentPopup(_ isPresented: Bool, for type: CollectionsViewPopOverModel) {
        withAnimation(.smooth(duration: 0.4)) {
            setPopOverItem((isPresented, type))
        }
        
        guard !isPresented else { return }
        resetTextfieldTexts()
        Task {
            // Adds one millisecond to popup animation duration to reset once the popup dismisses properly.
            try? await Task.sleep(nanoseconds: 400_000_000)
            resetUpdatingItem()
        }
    }
    
    func onCollectionItemsArrayChange(oldValue: Int, newValue: Int, scrollPosition: Binding<ScrollPosition>) {
        guard oldValue != 0, oldValue < newValue else { return }
        withAnimation {
            scrollPosition.wrappedValue.scrollTo(edge: .bottom)
        }
    }
}
