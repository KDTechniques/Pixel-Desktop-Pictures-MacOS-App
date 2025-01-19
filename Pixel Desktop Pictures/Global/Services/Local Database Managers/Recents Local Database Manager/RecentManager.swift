//
//  RecentManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation

actor RecentManager {
    // MARK: - SINGLETON
    private static var singleton: RecentManager?
    
    // MARK: - PROPERTIES
    let localDatabaseManager: RecentLocalDatabaseManager
    
    // MARK: - INITIALIZER
    private init(localDatabaseManager: RecentLocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    static func shared(localDatabaseManager: RecentLocalDatabaseManager) -> RecentManager {
        guard singleton == nil else {
            return singleton!
        }
        
        let newInstance: Self = .init(localDatabaseManager: localDatabaseManager)
        singleton = newInstance
        return newInstance
    }
    
    // MARK: - Create Operations
    
    func addRecent(_ newItem: Recent) async throws {
        try await localDatabaseManager.addRecent(newItem)
    }
    
    // MARK: - Read Operations
    
    func getRecents() async throws -> [Recent] {
        try await localDatabaseManager.fetchRecents()
    }
    
    func getImageTypeEncoded(for type: RecentImage) throws -> Data {
        let imageTypeEncoded: Data = try JSONEncoder().encode(type)
        return imageTypeEncoded
    }
    
    func getImageURLs(from item: Recent) async throws -> UnsplashImage {
        // First, decode data.
        let imageTypeDecoded: RecentImage = try JSONDecoder().decode(RecentImage.self, from: item.imageTypeEncoded)
        
        var imageQualityURLStrings: UnsplashImage = try {
            switch imageTypeDecoded {
            case .queryImage:
                guard let data: Data = item.queryImageEncoded else {
                    throw URLError(.badURL)
                }
                
                var imageURLs: UnsplashQueryImage = try JSONDecoder().decode(UnsplashQueryImage.self, from: data)
                return imageURLs.imageQualityURLStrings
                
            case .randomImage:
                guard let data: Data = item.randomImageEncoded else {
                    throw URLError(.badURL)
                }
                
                let imageURLs: UnsplashRandomImage = try JSONDecoder().decode(UnsplashRandomImage.self, from: data)
                return imageURLs.imageQualityURLStrings
            }
        }()
        
        // Then modify thumbnail sizing.
        let updatedThumbURL: String = imageQualityURLStrings.thumb.replacingOccurrences( // Note: If this 50 width has no impact on UX, remove this line
            of: "(?<=\\b)w=200(?=&|$)",
            with: "w=50",
            options: .regularExpression
        )
        
        imageQualityURLStrings.thumb = updatedThumbURL
        
        // Return modified `UnsplashImage` item.
        return imageQualityURLStrings
    }
    
    // MARK: - Update Operations
    
    func updateRecents() async throws {
        try await localDatabaseManager.updateRecents()
    }
    
    // MARK: - Delete Operations
    
    func deleteRecents(at items: [Recent]) async throws {
        try await localDatabaseManager.deleteRecents(at: items)
    }
}
