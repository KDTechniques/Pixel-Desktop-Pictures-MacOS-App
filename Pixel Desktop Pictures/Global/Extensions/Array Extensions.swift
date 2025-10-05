//
//  Array Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

extension Array where Element: Equatable {
    func getNextIndex(_ currentIndex: Int) -> Int {
        let lastIndex: Int = self.count-1
        return currentIndex < lastIndex ? currentIndex+1 : 0
    }
    
    func getMatchedIndex(for item: Element) -> Int? {
        return self.firstIndex(where: { $0 == item})
    }
}
