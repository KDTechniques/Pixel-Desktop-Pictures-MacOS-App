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
    
    static let mockObjectsArray: [Self] = [
        .init(collectionName: "Nature", imageURLString: "https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-fall-nature-scenery-free-image.jpeg?w=600&quality=80"),
        .init(collectionName: "Space", imageURLString: "https://external-preview.redd.it/7BQ9Ig391FbwCzMSgnCCgrzbEpnWXufcUSKwe6g7GXI.jpg?width=1080&crop=smart&auto=webp&s=c01b713490362ad78d7cf8dbb327c329476fb025"),
        .init(collectionName: "Animals", imageURLString: "https://t3.ftcdn.net/jpg/06/90/65/52/360_F_690655280_428Xo4M4LTwKQnOiRWBlFMx66sRXg4Xf.jpg"),
        .init(collectionName: "Abstract", imageURLString: "https://img.pikbest.com/ai/illus_our/20230428/a831e293e8f2a502eb0b358bd37e14b3.jpg!bw700"),
        .init(collectionName: "Black & White", imageURLString: "https://images.squarespace-cdn.com/content/v1/5fe4caeadae61a2f19719512/7e3b6672-3567-4797-b576-6212d3331875/Firewatch%20Tower"),
    ]
}
