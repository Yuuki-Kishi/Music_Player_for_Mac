//
//  StringExtension.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//
import Foundation

extension String {
    var bookmarkDataURL: URL? {
        let fullPath = URL(fileURLWithPath: self).standardizedFileURL.planePath
        for bookmarkDataURL in ReadFolderRepository.getReadFolder().compactMap({ $0.bookmarkDataURL }) {
            let bookmarkDataPath = bookmarkDataURL.planePath
            let bookmarkDataPathWithSlash = bookmarkDataPath.hasSuffix("/") ? bookmarkDataPath : bookmarkDataPath + "/"
            if fullPath.hasPrefix(bookmarkDataPathWithSlash) || fullPath == bookmarkDataPath {
                return bookmarkDataURL
            }
        }
        return nil
    }
    
    var filePath: String? {
        guard let bookmarkDataURL = self.bookmarkDataURL else { return nil }
        return URL(filePath: self).planePath.replacingOccurrences(of: bookmarkDataURL.planePath, with: "")
    }
}

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
