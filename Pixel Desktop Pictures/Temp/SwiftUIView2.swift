//
//  SwiftUIView2.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import SwiftUI

struct SwiftUIView2: View {
    @State private var networkManager: NetworkManager = .init()
    var apiService: UnsplashAPIService = .init(apiAccessKey: "Gqa1CTD4LkSdLlUlKH7Gxo8EQNZocXujDfe26KlTQwQ")
    
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
                    let imageDownloadManager: ImageDownloadManager = .init()
                    
                    do {
                        let model = try await apiService.getRandomImageModel()
                        let _ = try await imageDownloadManager.downloadImage(url: model.imageQualityURLStrings.full, to: .downloadsDirectory)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Get Query Image Model") {
                Task {
                    let imageDownloadManager: ImageDownloadManager = .init()
                    do {
                        let model = try await apiService.getQueryImageModel(queryText: "bmw", pageNumber: 1)
                        let _ = try await imageDownloadManager.downloadImage(url: model.results.last!.imageQualityURLStrings.regular, to: .downloadsDirectory)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIView2()
        .padding()
}
