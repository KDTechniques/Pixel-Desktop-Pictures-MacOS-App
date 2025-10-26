//
//  LaunchAtLoginAlertPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-11.
//

import SwiftUI

struct LaunchAtLoginAlertPopupView: View {
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 20) {
            Text(LaunchAtLoginAlertModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            LaunchAtLoginAlertModel.message
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack {
                Button("Enable at Login") {  }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(.orange.gradient)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.horizontal, 50)
                
                Button("Not Now", role: .cancel) { }
               
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

// MARK: - PREVIEWS
#Preview {
    LaunchAtLoginAlertPopupView()
        .previewModifier
}
