//
//  APIAccessKeyInstructionsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct APIAccessKeyInstructionsView: View {
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Text("To get your own Unsplash API Access Key:")
            
            VStack(alignment: .leading, spacing: 10) {
                first
                second
                third
                fourth
                fifth
                sixth
            }
            .font(.footnote)
            .padding(8)
            .fixedSize(horizontal: false, vertical: true)
            .background { background }
        }
    }
}

// MARK: - PREVIEWS
#Preview("API Access Key Instructions View") {
    APIAccessKeyInstructionsView()
        .padding()
        .frame(width: TabItems.allWindowWidth)
}

// MARK: - EXTENSIONS
extension APIAccessKeyInstructionsView {
    // MARK: - First Instruction
    private var first: some View {
        APIAccessKeyInstructionItemView {
            Text("1. Visit Unsplash Developers")
            Text("• Go to the [Unsplash Developer Portal](https://unsplash.com/developers) in your web browser.")
        }
    }
    
    // MARK: - Second Instruction
    private var second: some View {
        APIAccessKeyInstructionItemView {
            Text("2. Log In or Sign Up")
            Text("• If you already have an Unsplash account, log in with your credentials.")
            Text("• If not, create a free Unsplash account by clicking \"Join Free\" and completing the sign-up process.")
        }
    }
    
    // MARK: - Third Instruction
    private var third: some View {
        APIAccessKeyInstructionItemView {
            Text("3. Create a New Application")
            Text("• After logging in, click on your profile picture in the top-right corner and select \"API/Developers\".")
            Text("• Click on the \"New Application\" button.")
        }
    }
    
    // MARK: - Fourth Instruction
    private var fourth: some View {
        APIAccessKeyInstructionItemView {
            Text("4. Fill Out Application Details")
            Text("• Enter a name for your application (e.g., \"My Wallpaper App\").")
            Text("• Add the following brief description of what this app does.")
            
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(appDescription, forType: .string)
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
    }
    
    // MARK: - Fifth Instruction
    private var fifth: some View {
        APIAccessKeyInstructionItemView {
            Text("5. Submit Your Application")
            Text("• Click \"Create Application\" at the bottom of the form.")
        }
    }
    
    // MARK: - Sixth Instruction
    private var sixth: some View {
        APIAccessKeyInstructionItemView {
            Text("6. Get Your API Key")
            Text("• After creating the application, you’ll see your Access Key.")
            Text("• Copy the access key and paste it into the input field below.")
        }
    }
    
    // MARK: - Background
    private var background: some View {
        Color.textfieldBackground
            .clipShape(.rect(cornerRadius: 5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.textfieldBorder, lineWidth: 1)
            }
    }
    
    private var appDescription: String {
"""
The `Pixel Desktop Pictures` app is designed to enhance the macOS desktop experience by automatically setting a new wallpaper at hourly, daily, or weekly intervals. It retrieves high-quality images from the Unsplash API, ensuring a fresh and visually appealing backdrop every time. Seamlessly integrating with macOS, the app downloads images and updates the desktop picture without requiring any user intervention. This creates a dynamic, ever-changing desktop environment that inspires creativity and boosts productivity.
"""
    }
}
