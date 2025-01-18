//
//  ErrorPopupViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import Foundation

/**
 A view model responsible for managing error messages that are displayed in a popup.
 It manages a queue of error messages and ensures they are shown sequentially with appropriate delays and animations.
 */

@MainActor
@Observable
final class ErrorPopupViewModel {
    // MARK: - SINGLETON
    static let shared: ErrorPopupViewModel = .init()
    
    // MARK: - PROPERTIES
    @ObservationIgnored private var errorQueue: [String] = []
    private(set) var currentError: String? = nil
    @ObservationIgnored private var isProcessing = false // Timer to track when the current alert is dismissed
    private let animationDuration: TimeInterval = 4
    private let animationDelay: TimeInterval = 0.5
    
    // MARK: - INITIALIZER
    private init() {}
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Adds an error to the error queue if it is not already in the queue or being displayed.
    /// The error is added based on its title, and if no error is currently being processed, the next error in the queue will be shown.
    ///
    /// - Parameter error: The error that conforms to `ErrorPopupProtocol` to be added to the queue.
    /// - Note: The error will be processed and shown sequentially with delays, and duplicate errors will not be added to the queue.
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
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Displays the next error in the queue after the current error is dismissed.
    /// The current error is displayed for a defined duration, followed by a delay before showing the next error in the queue.
    ///
    /// - Note: The function is recursive, and the errors are processed one by one, ensuring that only one error is displayed at a time.
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
    
    /// Dismisses the currently displayed error and sets the `currentError` property to nil.
    /// This function is called after the defined duration for the current error has passed.
    ///
    /// - Note: This function is used to clear the error before displaying the next one in the queue.
    private func dismissCurrentError() {
        currentError = nil
    }
}
