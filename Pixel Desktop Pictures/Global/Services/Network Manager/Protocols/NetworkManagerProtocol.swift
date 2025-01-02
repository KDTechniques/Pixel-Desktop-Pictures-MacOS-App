//
//  NetworkManagerProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

protocol NetworkManagerProtocol {
    // MARK: - PROPERTIES
    var connectionStatus: InternetConnectionStatusModel { get async }
}
