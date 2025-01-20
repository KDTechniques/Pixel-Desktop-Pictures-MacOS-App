//
//  MockUnsplashImageDirectoryModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

enum MockUnsplashImageDirectoryModel: UnsplashImageDirectoryModelProtocol {
    case downloadsDirectory, documentsDirectory
    
    var directory: FileManager.SearchPathDirectory {
        switch self {
        case .downloadsDirectory:
            return .downloadsDirectory
        case .documentsDirectory: // Note: Simulate Documents Directory in the Downloads Directory for Ease of Testing
            return .downloadsDirectory
        }
    }
    
    var folderName: String {
        switch self {
        case .downloadsDirectory:
            return "(Mock-temp) Pixel Desktop Picture Downloads"
        case .documentsDirectory:
            return "(Mock-temp) Pixel Desktop Picture"
        }
    }
    
    var fileName: String {
        switch self {
        case .downloadsDirectory:
            return "(Mock-temp)" + UUID().uuidString
        case .documentsDirectory:
            return "(Mock-temp) Desktop Picture"
        }
    }
    
    func createDirectoryIfNeeded() throws -> URL {
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
    
    func deletePreviousDesktopPictures() throws {
        let fileManager: FileManager = .default
        
        guard let directoryURL = fileManager
            .urls(for: directory, in: .userDomainMask)
            .first else {
            throw UnsplashImageDirectoryModelErrorModel.unableToReadDirectoryPath(directory: directory)
        }
        
        let folderURL: URL = directoryURL.appending(path: folderName)
        
        do {
            // Get the list of files in the directory
            let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
            
            // Iterate through each file and delete it
            for fileURL in contents {
                if fileURL.hasDirectoryPath {
                    // Skip subdirectories
                    continue
                }
                
                do {
                    try fileManager.removeItem(at: fileURL)
                    print("Deleted: \(fileURL.lastPathComponent)")
                } catch {
                    print("Failed to delete: \(fileURL.lastPathComponent) - Error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error accessing directory: \(error.localizedDescription)")
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
