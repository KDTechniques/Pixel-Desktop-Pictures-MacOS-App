//
//  Download.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

extension MainTabViewModel {
    /// Downloads the current image to the device's downloads directory, and opens both  folder and the file at the same time.
    ///
    /// - Throws: An error if the download operation fails.
    func downloadImageToDevice(environment: AppEnvironment) async throws {
        // Early exit if the current image is not available.
        guard let currentImage else {
            Logger.log(vmError.failedToDownloadImageToDeviceCurrentImageNil.localizedDescription)
            return
        }
        
        // Get the downloads directory based on app environment
        let downloadsDirectory = DirectoryTypes.downloads.directory
        
        do {
            // Download the image to downloads directory
            let savedPathFileURL: URL = try await ImageDownloadManager.shared.downloadImage(url: currentImage.links.downloadURL, to: downloadsDirectory)
            
            // Extract folder and file URL String omitting percent encoding
            let savedPathFileURLString: String = savedPathFileURL.path(percentEncoded: false)
            let savedPathFolderURLString: String = savedPathFileURL.deletingLastPathComponent().path(percentEncoded: false)
            
            // Open both folder and file after a successful image download
            openFolderNFile(folderURLString: savedPathFolderURLString,  fileURLString: savedPathFileURLString)
            Logger.log("✅: Downloaded current image to `Downloads` folder path: `\(savedPathFileURL.absoluteString)`")
        } catch {
            Logger.log(vmError.failedToDownloadImageToDevice(error).localizedDescription)
            await errorPopupVM.addError(errorPopup.failedToDownloadImageToDevice)
            throw error
        }
    }
    
    private func openFolderNFile(folderURLString: String, fileURLString: String) {
        let process = Process()
        process.launchPath = "/usr/bin/open"
        process.arguments = [folderURLString, fileURLString]
        process.launch()
    }
}
