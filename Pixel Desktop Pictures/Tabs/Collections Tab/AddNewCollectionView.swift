//
//  AddNewCollectionView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct AddNewCollectionView: View {
    
    @Binding var isPresentedPopup: Bool
    @State private var collectionNameTextfieldText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter a keyword for a custom collection:")
            
            TextField("", text: $collectionNameTextfieldText, prompt: Text("Ex: Landscapes"))
                .textFieldStyle(.plain)
                .textSelection(.enabled)
                .padding(5)
                .padding(.trailing, 25)
                .background(
                    Color.textfieldBackground
                        .clipShape(.rect(cornerRadius: 5))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.textfieldBorder, lineWidth: 1)
                        }
                )
                .overlay(alignment: .trailing) {
                    Button {
                        collectionNameTextfieldText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .padding(5)
                    }
                    .buttonStyle(.plain)
                    .opacity(collectionNameTextfieldText == "" ? 0 : 1)
                }
            
            Button {
                // set desktop pictire action goes here...
            } label: {
                Text("Create")
                    .foregroundStyle(Color.popupButtonForeground)
                    .fontWeight(.medium)
                    .overlay(alignment: .trailing) {
                        ProgressView()
                            .frame(width: 0, height: 0)
                            .scaleEffect(0.35)
                            .offset(x: 10)
                    }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.popupButtonBackground, in: .rect(cornerRadius: 5))
        }
        .padding()
        .background(Color.popupBackground)
        .overlay(alignment: .topTrailing) {
            Button {
                isPresentedPopup = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
                    .padding(5)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview("Add New Collection View") {
    AddNewCollectionView(isPresentedPopup: .constant(false))
        .frame(width: 375)
}
