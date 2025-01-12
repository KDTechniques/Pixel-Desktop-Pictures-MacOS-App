//
//  RecentImageURLModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

@Model
final class RecentImageURLModel {
    var downloadedDate: Date // Ex: 2025-01-01 11:12:54 AM +0000
    var imageURLString: String // Ex: "https://www.example.com/Nature/image5"
    
    init(downloadedDate: Date, imageURLString: String) {
        self.downloadedDate = downloadedDate
        self.imageURLString = imageURLString
    }
}
