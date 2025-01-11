//
//  WindowErrorModelProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

protocol WindowErrorModelProtocol {
    associatedtype T: View
    
    var title: String { get }
    var message: T { get }
}
