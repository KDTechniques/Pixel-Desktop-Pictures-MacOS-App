//
//  SwiftUIView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-30.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var sampleClass: Sample = .init()
    
    var body: some View {
        Button("Throw error") {
            sampleClass.throwAnerror()
            sampleClass.throwAnerror()
        }
        
    }
}

#Preview {
    TabsView()
}

@MainActor
@Observable final class Sample {
    private let scheduler = DesktopPictureScheduler.init(timeIntervalModel: MockDesktopPictureSchedulerIntervals.self) {
        print("Hi there...")
    }
    
    func throwAnerror() {
        Task {
            await scheduler.throwAnError()
        }
    }
}
