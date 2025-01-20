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
    
    func getImageURLs(from item: Recent) async throws -> UnsplashImageResolution {
        // First, decode data.
        let imageDecoded: UnsplashImage = try JSONDecoder().decode(UnsplashImage.self, from: item.imageEncoded)
        
        // Assign `imageQualityURLStrings` to a temp property to avoid making changes to local database.
        var tempImageQualityURLStrings: UnsplashImageResolution = imageDecoded.imageQualityURLStrings
        
        // Then modify thumbnail sizing.
        let updatedThumbURL: String = tempImageQualityURLStrings.thumb.replacingOccurrences( // Note: If this 50 width has no impact on UX, remove this line
            of: "(?<=\\b)w=200(?=&|$)",
            with: "w=50",
            options: .regularExpression
        )
        
        tempImageQualityURLStrings.thumb = updatedThumbURL
        
        // Return modified `UnsplashImageResolution` item.
        return tempImageQualityURLStrings
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
