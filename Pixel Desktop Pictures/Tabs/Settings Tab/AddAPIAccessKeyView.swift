//
//  AddAPIAccessKeyView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct AddAPIAccessKeyView: View {
    
    @Binding var isPresentedPopup: Bool
    @State private var apiAccessKeyTextfieldText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Instructions
            Text("To get your own Unsplash API Access Key:")
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("1. Visit Unsplash Developers")
                    Text("• Go to the [Unsplash Developer Portal](https://unsplash.com/developers) in your web browser.")
                }
                
                VStack(alignment: .leading) {
                    Text("2. Log In or Sign Up")
                    Text("• If you already have an Unsplash account, log in with your credentials.")
                    Text("• If not, create a free Unsplash account by clicking \"Join Free\" and completing the sign-up process.")
                }
                
                VStack(alignment: .leading) {
                    Text("3. Create a New Application")
                    Text("• After logging in, click on your profile picture in the top-right corner and select \"API/Developers\".")
                    Text("• Click on the \"New Application\" button.")
                }
                
                VStack(alignment: .leading) {
                    Text("4. Fill Out Application Details")
                    Text("• Enter a name for your application (e.g., \"My Wallpaper App\").")
                    Text("• Add the following brief description of what this app does.")
                    
                    Button {
                        // set the description to clipboard action goes here...
                    } label: {
                        HStack(spacing: 2) {
                            Text("• Click here to copy description to clipboard")
                                .fontWeight(.medium)
                            
                            Image(systemName: "doc.on.doc.fill")
                                .font(.footnote)
                        }
                    }
                    .foregroundStyle(Color.accentColor)
                    .buttonStyle(.plain)
                    
                    Text("• Leave other fields blank.")
                }
                
                VStack(alignment: .leading) {
                    Text("5. Submit Your Application")
                    Text("• Click \"Create Application\" at the bottom of the form.")
                }
                
                VStack(alignment: .leading) {
                    Text("6. Get Your API Key")
                    Text("• After creating the application, you’ll see your Access Key.")
                    Text("• Copy the access key and paste it into the input field below.")
                }
            }
            .font(.footnote)
            .padding(8)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                Color.textfieldBackground
                    .clipShape(.rect(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.textfieldBorder, lineWidth: 1)
                    }
            )
            
            Text("Copy, Paste your Unsplash API Access Key here:")
                .padding(.top)
            
            TextField("", text: $apiAccessKeyTextfieldText, prompt: Text("Ex: 2in4w8v0oGOqdQdPsnKBF2d5-je8fyJs8YkEsfvNaY0"))
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
                        apiAccessKeyTextfieldText = ""
                    } label: {
                        Group {
                            if apiAccessKeyTextfieldText == "" {
                                Button {
                                    // paste from clipboard action goes here...
                                } label: {
                                    Image(systemName: "doc.on.clipboard.fill")
                                        .font(.footnote)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.trailing, 5)
                    }
                    .buttonStyle(.plain)
                }
            
            // Connect Button
            Button {
                // set desktop pictire action goes here...
            } label: {
                Text("Connect")
                    .foregroundStyle(Color.popupButtonForeground)
                    .fontWeight(.medium)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.popupButtonBackground, in: .rect(cornerRadius: 5))
            .disabled(apiAccessKeyTextfieldText.isEmpty ? true : false)
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

#Preview("Add API Access Key View") {
    AddAPIAccessKeyView(isPresentedPopup: .constant(false))
        .frame(width: 375)
}
