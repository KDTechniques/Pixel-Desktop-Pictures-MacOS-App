//
//  ErrorPopupViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import Foundation

@MainActor
@Observable
final class ErrorPopupViewModel {
    // MARK: - PROPERTIES
    @ObservationIgnored
    private var errorQueue: [String] = []
    private(set) var currentError: String? = nil
    @ObservationIgnored
    private var isProcessing = false // Timer to track when the current alert is dismissed
    private let animationDuration: TimeInterval = 4
    private let animationDelay: TimeInterval = 0.5
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Add Error
    func addError(_ error: any ErrorPopupProtocol) async {
        let errorTitle: String = error.title
        // Add the error only if it's not already in the queue or being displayed
        if !errorQueue.contains(errorTitle) && currentError != errorTitle {
            errorQueue.append(errorTitle)
        }
        
        if !isProcessing {
            await showNextError()
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Show Next Error
    private func showNextError() async {
        guard !errorQueue.isEmpty else { return }
        
        isProcessing = true // Start processing
        
        // Set the current error
        currentError = errorQueue.removeFirst()
        
        // Wait to display the current alert
        try? await Task.sleep(nanoseconds: UInt64(animationDuration * 1_000_000_000))
        
        // Dismiss the current alert
        dismissCurrentError()
        
        // Wait before showing the next alert
        try? await Task.sleep(nanoseconds: UInt64(animationDelay * 1_000_000_000))
        
        isProcessing = false // Ready for the next error
        
        // Show the next error, if any
        await showNextError()
    }
    
    // MARK: - Dismiss Current Error
    private func dismissCurrentError() {
        currentError = nil
    }
}
