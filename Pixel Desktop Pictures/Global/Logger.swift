//
//  Logger.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-26.
//

import Foundation

struct Logger {
    private static var messages: [String] = []
    
    static func log(_ message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        let fileNameWithoutPath = (fileName as NSString).lastPathComponent
        let DateString: String = Date.now.formatted(date: .numeric, time: .standard)
        let formatted = "\(DateString): [\(fileNameWithoutPath):\(lineNumber)] \(functionName): \(message)\n"
        
        print(formatted)
        messages.append(formatted)
    }
    
    static func allLogs() -> [String] {
        return messages
    }
    
    static func clear() {
        messages.removeAll()
    }
}
