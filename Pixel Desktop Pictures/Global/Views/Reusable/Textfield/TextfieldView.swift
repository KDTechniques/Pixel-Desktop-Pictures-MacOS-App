//
//  TextfieldView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUI

struct TextfieldView: View {
    // MARK: - PROPERTIES
    @Binding var textfieldText: String
    let localizedKey: String
    let prompt: String
    let onSubmission: () -> ()
    
    // MARK: - INITIALIZER
    init(textfieldText: Binding<String>, localizedKey: String, prompt: String, onSubmission: @escaping () -> ()) {
        _textfieldText = textfieldText
        self.localizedKey = localizedKey
        self.prompt = prompt
        self.onSubmission = onSubmission
    }
    
    // MARK: - BODY
    var body: some View {
        TextField(localizedKey, text: $textfieldText, prompt: Text(prompt))
            .textFieldStyle(.plain)
            .textSelection(.enabled)
            .padding(5)
            .padding(.trailing, 25)
            .background( TextfieldBackgroundView() )
            .overlay(alignment: .trailing) { clearButton }
            .onSubmit { onSubmission() }
    }
}

// MARK: - PREVIEWS
#Preview("Textfield View") {
    @Previewable @State var textfieldText: String = ""
    TextfieldView(textfieldText: $textfieldText, localizedKey: "", prompt: "Type here...") {
        print("Submitted!")
    }
    .padding()
}

// MARK: - EXTENSIONS
extension TextfieldView {
    // MARK: - Clear Button
    @ViewBuilder
    private var clearButton: some View {
        if !textfieldText.isEmpty {
            Button {
                textfieldText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 5)
            }
            .buttonStyle(.plain)
        }
    }
}
