//
//  UnsplashImageDirectory.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import Foundation

/**
 An enumeration representing directories for Unsplash images, conforming to the `UnsplashImageDirectoryProtocol`.
 This is used to manage image storage in the Downloads and Documents directories.
 */
enum UnsplashImageDirectory: UnsplashImageDirectoryProtocol {
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
    
    private var fileName: String { UUID().uuidString }
    
    /// Creates the directory if it does not exist and returns its URL.
    /// - Throws: An error if the directory path cannot be read or the directory creation fails.
    /// - Returns: The URL of the created directory.
    private func createDirectoryIfNeeded() throws -> URL {
        guard let directoryURL = FileManager.default
            .urls(for: directory, in: .userDomainMask)
            .first else {
            throw UnsplashImageDirectoryModelError.unableToReadDirectoryPath(directory: directory)
        }
        
        let folderURL: URL = directoryURL.appending(path: folderName)
        
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            return folderURL
        } catch {
            Logger.log("❌: Creating Folder Directory in \(directory).")
            throw error
        }
    }
    
    /// Deletes all previous desktop pictures in the Documents directory.
    /// Avoids removing all files in the Downloads folder.
    /// - Throws: An error if the directory path cannot be read or accessed.
    func deletePreviousDesktopPictures() throws {
        // Avoid removing all the files in the downloads folder
        guard directory == .documentDirectory else { return }
        
        let fileManager: FileManager = .default
        
        guard let directoryURL = fileManager
            .urls(for: directory, in: .userDomainMask)
            .first else {
            throw UnsplashImageDirectoryModelError.unableToReadDirectoryPath(directory: directory)
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
                    Logger.log("Deleted: \(fileURL.lastPathComponent)")
                } catch {
                    Logger.log("Failed to delete: \(fileURL.lastPathComponent) - Error: \(error.localizedDescription)")
                }
            }
        } catch {
            Logger.log("Error accessing directory: \(error.localizedDescription)")
        }
    }
    
    /// Constructs the full file URL for a file with the given extension.
    /// - Parameter fileExtension: The file extension to append to the file name.
    /// - Throws: An error if the directory cannot be created or the URL construction fails.
    /// - Returns: The full file URL including the extension.
    func fileURL(extension fileExtension: String) throws -> URL {
        do {
            let fileURL: URL = try createDirectoryIfNeeded()
                .appending(path: fileName)
                .appendingPathExtension(fileExtension)
            
            return fileURL
        } catch {
            Logger.log("❌: Constructing file url in \(directory). \(error.localizedDescription)")
            throw UnsplashImageDirectoryModelError.fileURLConstructionFailed(directory: directory, error: error)
        }
    }
}
