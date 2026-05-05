//
//  StringExtension.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//
import Foundation

extension Array where Element == String {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(string: Element) {
        if let index = self.firstIndex(of: string) {
            self.remove(at: index)
        }
    }
}
