//
//  ImagePreviewView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct ImagePreviewView: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding()
            
            // Image Preview
            Rectangle()
                .foregroundStyle(.mint)
                .frame(height: 200)
                .overlay {
                    Group {
                        ProgressView()
                            .scaleEffect(0.65)
                            .opacity(1)
                        
                        Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .opacity(1)
                    }
                    .frame(width: 50, height: 40)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            
            // Set Desktop Picture Button
            VStack {
                Button {
                    // set desktop pictire action goes here...
                } label: {
                    Text("Set Desktop Picture")
                        .foregroundStyle(Color.buttonForeground)
                        .fontWeight(.medium)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
                
                // Author and Download Button
                HStack {
                    HStack(spacing: 3) {
                        Text("By")
                        Text("Nicole Geri")
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Button("Download") {
                        // download image to downloads folder action goes here...
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

#Preview("Image Preview View") {
    ImagePreviewView()
        .frame(width: 375)
        .background(.white)
}
