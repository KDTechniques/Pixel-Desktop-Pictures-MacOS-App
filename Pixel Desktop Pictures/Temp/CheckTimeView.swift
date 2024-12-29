//
//  CheckTimeView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-29.
//

import SwiftUI

struct CheckTimeView: View {
    var body: some View {
        VStack(alignment: .trailing) {
            Text("\(Date().addingTimeInterval(15*60).timeIntervalSince1970)")
            
            Text("\(Date().timeIntervalSince1970)")
        }
    }
}

#Preview {
    CheckTimeView()
        .padding()
}
