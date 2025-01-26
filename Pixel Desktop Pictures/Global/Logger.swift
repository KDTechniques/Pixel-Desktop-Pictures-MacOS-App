//
//  Logger.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-26.
//

import Foundation

struct Logger {
    static func log(_ message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
#if DEBUG
        let fileNameWithoutPath = (fileName as NSString).lastPathComponent
        print("[\(fileNameWithoutPath):\(lineNumber)] \(functionName): \(message)")
#endif
    }
}
