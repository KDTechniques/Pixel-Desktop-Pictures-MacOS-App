//
//  CheckboxTextView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct CheckboxTextView: View {
    //MARK: - PROPERTIES
    @Binding var isChecked: Bool
    let text: String
    
    // MARK: - INITIALIZER
    init(isChecked: Binding<Bool>, text: String) {
        _isChecked = isChecked
        self.text = text
    }
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 3)
                .fill(isChecked ? Color.accentColor : Color.buttonBackground)
                .frame(width: 12, height: 12)
                .overlay { checkBox }
                .onTapGesture { handleTap() }
            
            TextView(text: text)
        }
    }
}

// MARK: - EXTENSIONS
extension CheckboxTextView {
    // MARK: - checkBox
    private var checkBox: some View {
        Image(systemName: "checkmark")
            .resizable()
            .scaledToFit()
            .frame(width: 8)
            .foregroundStyle(.white)
            .fontWeight(.heavy)
            .opacity(isChecked ? 1 : 0)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle Tap
    private func handleTap() {
        isChecked.toggle()
    }
}

// MARK: SUB VIEWS

// MARK: - Text View
fileprivate struct TextView: View {
    // MARK: - PROPERTIES
    let text: String
    
    // MARK: - INITIALIZER
    init(text: String) {
        self.text = text
    }
    
    // MARK: - BODY
    var body: some View {
        Text(text)
    }
}

// MARK: - PREVIEWS
#Preview("Checkbox Text View") {
    @Previewable @State var isChecked: Bool = false
    CheckboxTextView(isChecked: $isChecked, text: "Is checked")
        .padding()
}

#Preview("Text View") {
    TextView(text: "Is checked")
        .padding()
}

