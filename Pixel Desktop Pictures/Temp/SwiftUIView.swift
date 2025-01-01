//
//  SwiftUIView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-30.
//

import SwiftUI

struct SwiftUIView: View {
    @State var testingClass: TestingClass = .init()
    
    var body: some View {
        Text("Thank You!")
            .onFirstTaskViewModifier {
                print(Date())
                await testingClass.initializeDesktopPictureScheduler()
            }
    }
}

@Observable final class TestingClass {
    let scheduler: DesktopPictureScheduler = .init(timeIntervalModel: MockDesktopPictureSchedulerIntervals.self) {
        print("Background task goes here...")
    }
    
    func initializeDesktopPictureScheduler() async {
        await scheduler.initializeScheduler()
    }
}
