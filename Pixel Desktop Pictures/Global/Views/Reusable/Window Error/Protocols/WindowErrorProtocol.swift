//
//  WindowErrorProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

protocol WindowErrorProtocol {
    associatedtype T: View
    
    var title: String { get }
    var messageView: T { get }
    var withBottomPadding: Bool { get }
}
