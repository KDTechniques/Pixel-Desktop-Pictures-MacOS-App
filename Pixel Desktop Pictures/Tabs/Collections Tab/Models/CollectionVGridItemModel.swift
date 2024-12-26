//
//  CollectionVGridItemModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

struct CollectionVGridItemModel: Identifiable, Equatable, Hashable {
    var id: String { collectionName }
    let collectionName: String
    let imageURLString: String
    
    static let defaultItemsArray: [Self] = [
        .init(collectionName: "RANDOM", imageURLString: ""),
        .init(collectionName: "Nature", imageURLString: "https://plus.unsplash.com/premium_photo-1719943510748-4b4354fbcf56?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8TmF0dXJlfGVufDB8MHwwfHx8MA%3D%3D"),
        .init(collectionName: "Animals", imageURLString: "https://images.unsplash.com/photo-1521651201144-634f700b36ef?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTJ8fEFuaW1hbHN8ZW58MHwwfDB8fHwy"),
        .init(collectionName: "Places", imageURLString: "https://images.unsplash.com/photo-1677180202572-3cfec2fe3fca?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fFBsYWNlc3xlbnwwfDB8MHx8fDI%3D"),
        .init(collectionName: "Food & Drink", imageURLString: "https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fEZvb2QlMjAlMjYlMjBEcmlua3xlbnwwfDB8MHx8fDI%3D"),
        .init(collectionName: "Mountains", imageURLString: "https://images.unsplash.com/photo-1600298882525-1ac025c98b68?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fE1vdW50YWluc3xlbnwwfDB8MHx8fDI%3D"),
        .init(collectionName: "Abstract", imageURLString: "https://images.unsplash.com/photo-1486025402772-bc179c8dfb0e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fEFic3RyYWN0fGVufDB8MHwwfHx8Mg%3D%3D"),
        .init(collectionName: "Black & White", imageURLString: "https://images.unsplash.com/photo-1559075398-c61f41bbf892?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Njd8fEJsYWNrJTIwJTI2JTIwV2hpdGV8ZW58MHwwfDB8fHwy"),
    ]
}
