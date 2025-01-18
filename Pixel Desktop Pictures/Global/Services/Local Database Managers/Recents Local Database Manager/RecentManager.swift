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
    
    func fetchRecents() async throws -> [Recent] {
        try await localDatabaseManager.fetchRecents()
    }
    
    // MARK: - Delete Operations
    
    func deleteRecent(at item: Recent) async throws {
        try await localDatabaseManager.deleteRecent(at: item)
    }
}
