//
//  MainTabDeferredOperations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-06-20.
//

import Foundation

struct MainTabDeferredOperationModel: Hashable {
    let id: String = UUID().uuidString
    let type: MainTabDeferredOperationTypes
    let action: () async throws -> ()
    
    init(type: MainTabDeferredOperationTypes, action: @escaping () async throws -> Void) {
        self.type = type
        self.action = action
    }
    
    static func == (lhs: MainTabDeferredOperationModel, rhs: MainTabDeferredOperationModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum MainTabDeferredOperationTypes {
    case  nextImage, setDesktopPicture, download
}
