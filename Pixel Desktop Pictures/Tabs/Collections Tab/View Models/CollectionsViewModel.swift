//
//  CollectionsViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

@MainActor
@Observable final class CollectionsViewModel {
    // MARK: - PROPERTIES
    private(set) var isPresentedPopup: Bool = false
    var collectionNameTextfieldText: String = ""
    @ObservationIgnored
    var popOverAnimation: (Animation, AnyHashable) { (.smooth(duration: 0.3), isPresentedPopup) }
    var collectionVGridItemsArray: [CollectionVGridItemModel] = CollectionVGridItemModel.mockObjectsArray
    let defaults: UserDefaults = .standard
#warning("remove the folling asignment later")
    var selectedCollectionsArray: [CollectionVGridItemModel] = [CollectionVGridItemModel.mockObjectsArray.first!]
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Collection
    func createCollection() {
        
    }
    
    // MARK: - Present & Dismiss Popup
    func presentPopup(_ isPresented: Bool) {
        isPresentedPopup = isPresented
    }
    
    // MARK: - Save Collection VGrid Items to User Defaults
    func saveCollectionVGridItemsToUserDefaults() {
        
    }
    
    // MARK: - Set Selected Collection
    func setSelectedCollection(_ item: CollectionVGridItemModel) {
        if let index: Int = selectedCollectionsArray.firstIndex(where: { $0.id == item.id }) {
            selectedCollectionsArray.remove(at: index)
        } else {
            selectedCollectionsArray.append(item)
        }
    }
}
