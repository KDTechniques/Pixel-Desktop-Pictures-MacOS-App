//
//  UnsplashImageDirectoryModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import Foundation

enum UnsplashImageDirectoryModel: UnsplashImageDirectoryModelProtocol {
    case downloadsDirectory, documentsDirectory
    
    private var directory: FileManager.SearchPathDirectory {
        switch self {
        case .downloadsDirectory:
            return .downloadsDirectory
        case .documentsDirectory:
            return .documentDirectory
        }
    }
    
    private var folderName: String {
        switch self {
        case .downloadsDirectory:
            return "Pixel Desktop Picture Downloads"
        case .documentsDirectory:
            return "Pixel Desktop Picture"
        }
    }
    
    private var fileName: String {
        switch self {
        case .downloadsDirectory:
            return UUID().uuidString
        case .documentsDirectory:
            return "Desktop Picture"
        }
    }
    
    private func createDirectoryIfNeeded() throws -> URL {
        guard let directoryURL = FileManager.default
            .urls(for: directory, in: .userDomainMask)
            .first else {
            throw UnsplashImageDirectoryModelErrorModel.unableToReadDirectoryPath(directory: directory)
        }
        
        let folderURL: URL = directoryURL.appending(path: folderName)
        
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            return folderURL
        } catch {
            print("❌: Creating Folder Directory in \(directory).")
            throw error
        }
    }
    
    func fileURL(extension fileExtension: String) throws -> URL {
        do {
            let fileURL: URL = try createDirectoryIfNeeded()
                .appending(path: fileName)
                .appendingPathExtension(fileExtension)
            
            return fileURL
        } catch {
            print("❌: Constructing file url in \(directory). \(error.localizedDescription)")
            throw UnsplashImageDirectoryModelErrorModel.fileURLConstructionFailed(directory: directory, error: error)
        }
    }
}
