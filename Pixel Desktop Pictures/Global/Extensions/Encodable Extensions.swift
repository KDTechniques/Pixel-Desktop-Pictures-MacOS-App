//
//  Encodable Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

extension Encodable {
    func printLineDescription() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted  // Makes the output pretty (indented)
            
            let jsonData = try encoder.encode(self)
            
            // Convert Data to a JSON string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Error encoding model: \(error)")
        }
    }
}
