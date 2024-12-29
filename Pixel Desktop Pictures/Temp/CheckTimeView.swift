//
//  CheckTimeView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-29.
//

import SwiftUI

struct CheckTimeView: View {
    
    var currentTimeIntervalSince1970: TimeInterval {
        Date().timeIntervalSince1970
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text("\(Date().addingTimeInterval(15*60).timeIntervalSince1970)")
            
            Text("\(Date().timeIntervalSince1970)")
            
            Button("get current time interval since 1970") {
                print(currentTimeIntervalSince1970.description)
            }
        }
    }
}

#Preview {
    CheckTimeView()
        .padding()
}
