//
//  SwiftUIView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import SwiftUI

struct SwiftUIView: View {
   
    let scheduler: DesktopPictureScheduler = .init(timeIntervalModel: MockDesktopPictureSchedulerIntervals.self) {
        print("Background Task Started!: \(Date())")
    }
    
    var body: some View {
        VStack {
            Button("Update Background Task to Hourly") {
                Task {
                    await scheduler.onChangeOfTimeIntervalSelection(from: MockDesktopPictureSchedulerIntervals.hourly)
                }
            }
            
            Button("Update Background Task to Daily") {
                Task {
                    await scheduler.onChangeOfTimeIntervalSelection(from: MockDesktopPictureSchedulerIntervals.daily)
                }
            }
            
            Button("Current Interval") {
                Task {
                    await scheduler.printCurrentTimeInterval()
                }
            }
            
            Button("Clear All User Defaults") {
                UserDefaultsManager.clearAllUserDefaults()
            }
        }
    }
}

#Preview {
    SwiftUIView()
        .padding()
}
