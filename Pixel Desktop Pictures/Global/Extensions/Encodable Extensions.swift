//
//  Encodable Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

extension Encodable {
    /// Prints a JSON representation of the current model using pretty-Logger.loged formatting.
    ///
    /// Encodes the model to JSON, handles potential encoding errors, and Logger.logs the result.
    ///
    /// - Note: Provides a formatted JSON string for debugging and logging purposes.
    func printLineDescription() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData = try encoder.encode(self)
            
            guard !jsonData.isEmpty else {
                Logger.log("Empty JSON data.")
                return
            }
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                Logger.log(jsonString)
            }
        } catch {
            Logger.log("Error encoding model: \(error)")
        }
    }
}
