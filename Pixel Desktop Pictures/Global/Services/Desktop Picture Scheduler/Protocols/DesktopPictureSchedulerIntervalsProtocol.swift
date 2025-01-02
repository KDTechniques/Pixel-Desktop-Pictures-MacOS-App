//
//  DesktopPictureSchedulerIntervalsProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol DesktopPictureSchedulerIntervalsProtocol {
    // MARK: - PROPERTIES
    var timeIntervalName: String { get }
    var timeInterval: TimeInterval { get }
    static var defaultTimeInterval: TimeInterval { get }
}
