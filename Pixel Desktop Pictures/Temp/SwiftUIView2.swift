//
//  SwiftUIView2.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import SwiftUI

struct SwiftUIView2: View {
    @State private var networkManager: NetworkManager = .init()
    var body: some View {
        Text(networkManager.connectionStatus.rawValue)
    }
}

#Preview {
    SwiftUIView2()
        .padding()
}
