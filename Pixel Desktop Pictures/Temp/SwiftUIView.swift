import SwiftUI

@MainActor
@Observable
final class ViewModel {
    @ObservationIgnored
    private(set) var errorQueue: [String] = []
    var currentError: String? = nil
    // Timer to track when the current alert is dismissed
    @ObservationIgnored
    private var isProcessing = false
    let animationDuration: TimeInterval = 3
    let animationDelay: TimeInterval = 0.5
    
    func onArrayChanged(_ error: String) {
        // Add the error only if it's not already in the queue or being displayed
        if !errorQueue.contains(error) && currentError != error {
            errorQueue.append(error)
        }
        
        if !isProcessing {
            Task { await showNextError() }
        }
    }
    
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
    
    private func dismissCurrentError() {
        currentError = nil
    }
}

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            // Main Content
            VStack {
                Button("Trigger Error 1") {
                    viewModel.onArrayChanged("Error 1")
                }
                Button("Trigger Error 2") {
                    viewModel.onArrayChanged("Error 2")
                }
                Button("Trigger Error 3") {
                    viewModel.onArrayChanged("Error 3")
                }
            }
            
            // Error View Overlay
            if let errorMessage = viewModel.currentError {
                ErrorView(message: errorMessage)
            }
        }
        .animation(.easeInOut, value: viewModel.currentError) // Smooth transition
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(8)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
            .padding()
            .transition(.move(edge: .top))
            .zIndex(1) // Ensure it's above other content
    }
}

#Preview {
    ContentView()
        .padding()
        .previewModifier
}
