//
//  ErrorPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct ErrorPopupView: View {
    // MARK: - PROPERTIES
    @Environment(ErrorPopupViewModel.self) private var errorPopupVM
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let error: String = errorPopupVM.currentError {
                Text(error)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
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
    @Previewable @State var errorPopupVM: ErrorPopupViewModel = .init()
    
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
                        await errorPopupVM.addError(CollectionsTabErrorPopupModel.duplicateCollectionNameFound)
                        await errorPopupVM.addError(CollectionsTabErrorPopupModel.failedToCreateCollection
                        )
                        await errorPopupVM.addError(CollectionsTabErrorPopupModel.somethingWentWrong)
                    }
                }
                
                Button("Trigger") {
                    Task { await errorPopupVM.addError(CollectionsTabErrorPopupModel.failedToCreateCollection
                    ) }
                }
                
                Button("Trigger") {
                    Task {  await errorPopupVM.addError(CollectionsTabErrorPopupModel.somethingWentWrong) }
                }
            }
            .padding()
        }
        .environment(errorPopupVM)
        .previewModifier
}
