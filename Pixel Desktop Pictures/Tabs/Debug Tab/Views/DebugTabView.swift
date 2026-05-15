//
//  DebugTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2026-05-07.
//

import SwiftUI

struct DebugTabView: View {
    // MARK: - BODY
    var body: some View {
        VStack {
            
        }
    }
}

// MARK: - PREVIEWS
#Preview("DebugTabView") {
    DebugTabView()
        .previewModifier
}

// To-DO List;

/*
 
 1. a button to check api rate limiting by inputting an api key, and or iterate through the hard coded api keys.
 - so this needs a dedicated section for rate limit checks, including a text field, two buttons, label to display the current validating api key.
 - another label to present the status of the validation for example .validating, .success, . rate limited, .invalid, .failed
 
 
 2. another section to check persistency of time intervals. It must show the saved data & time of the interval and when it's going to call the next iteration, like a range as it's decided by the system we can't state an exact date and time but a range.
 
 3. 
 
 
 
 */
