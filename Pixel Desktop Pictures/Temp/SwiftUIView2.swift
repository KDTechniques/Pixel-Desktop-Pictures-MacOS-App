//
//  SwiftUIView2.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import SwiftUI

struct SwiftUIView2: View {
    @State private var networkManager: NetworkManager = .init()
    var apiService: UnsplashImageAPIService = .init(apiAccessKey: "Gqa1CTD4LkSdLlUlKH7Gxo8EQNZocXujDfe26KlTQwQ")
    let desktopPictureManager: DesktopPictureManager = .shared
    let imageDownloadManager: ImageDownloadManager = .shared
    @State private var pageNumber: Int = 60
    
    var body: some View {
        VStack {
            Text(networkManager.connectionStatus.rawValue)
            
            Button("validate api access key") {
                Task {
                    do {
                        try await apiService.validateAPIAccessKey()
                        print("Connected")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Get Random Image Model") {
                Task {
                    
                    do {
                        let model = try await apiService.getRandomImageModel()
                        let imageFileURLString: String = try await imageDownloadManager.downloadImage(
                            url: model.imageQualityURLStrings.full,
                            to: MockUnsplashImageDirectoryModel.downloadsDirectory
                        )
                        
                        try await desktopPictureManager.setDesktopPicture(from: imageFileURLString)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Get Query Image Model") {
                Task {
                    do {
                        pageNumber += 1
                        let model = try await apiService.getQueryImageModel(queryText: "Black and White", pageNumber: pageNumber, imagesPerPage: 1)
                        let imageFileURLString: String = try await imageDownloadManager.downloadImage(
                            url: model.results.first!.imageQualityURLStrings.small,
                            to: MockUnsplashImageDirectoryModel.downloadsDirectory
                        )
                        print("URL: \(model.results.first!.imageQualityURLStrings.small) ❤️")
//                        try await desktopPictureManager.setDesktopPicture(from: imageFileURLString)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .padding()
        .onFirstTaskViewModifier {
            networkManager.initializeNetworkManager()
        }
    }
}

#Preview {
    SwiftUIView2()
        .padding()
}
