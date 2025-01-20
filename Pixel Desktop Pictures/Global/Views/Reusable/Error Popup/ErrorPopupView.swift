//
//  ErrorPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct ErrorPopupView: View {
    // MARK: - PROPERTIES
    let errorPopupVM: ErrorPopupViewModel = .shared
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let error: String = errorPopupVM.currentError {
                Text(error)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .padding(.top, TabItemsModel.tabHeaderHeight)
                    .background(.ultraThinMaterial)
                    .transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut, value: errorPopupVM.currentError)
    }
}

// MARK: - PREVIEWS
#Preview("Error Popup View") {
    let errorPopupVM: ErrorPopupViewModel = .shared
    
    Color.debug
        .overlay(alignment: .top) { ErrorPopupView() }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.windowBackground)
                .frame(height: TabItemsModel.tabHeaderHeight)
        }
        .overlay {
            VStack {
                Button("Trigger") {
                    Task {
                        await errorPopupVM.addError(CollectionsTabErrorPopup.duplicateCollectionNameFound)
                        await errorPopupVM.addError(CollectionsTabErrorPopup.failedToCreateCollection
                        )
                        await errorPopupVM.addError(CollectionsTabErrorPopup.somethingWentWrong)
                    }
                }
                
                Button("Trigger") {
                    Task { await errorPopupVM.addError(CollectionsTabErrorPopup.failedToCreateCollection
                    ) }
                }
                
                Button("Trigger") {
                    Task {  await errorPopupVM.addError(CollectionsTabErrorPopup.somethingWentWrong) }
                }
            }
            .padding()
        }
        .environment(errorPopupVM)
        .previewModifier
}
