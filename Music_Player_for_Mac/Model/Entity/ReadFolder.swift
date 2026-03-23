//
//  ReadFolder.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import Foundation

struct ReadFolder: Hashable, Identifiable, Equatable {
//    static func == (lhs: ReadFolder, rhs: ReadFolder) -> Bool {
//        lhs.folderPath == rhs.folderPath
//    }
    
    var id = UUID()
    var folderTitle: String
    var isRead: Bool
    var folderPath: String
    var bookmarkData: Data
    
    init(folderTitle: String, isRead: Bool, folderPath: String, bookmarkData: Data) {
        self.folderTitle = folderTitle
        self.isRead = isRead
        self.folderPath = folderPath
        self.bookmarkData = bookmarkData
    }
    
    init() {
        self.folderTitle = "unknownFolder"
        self.isRead = true
        self.folderPath = "unknownFolderPath"
        self.bookmarkData = Data()
    }
}

extension ReadFolder {
    var bookmarkDataURL: URL? {
        do {
            var isState: Bool = false
            let bookmarkDataURL = try URL(resolvingBookmarkData: self.bookmarkData, options: [.withSecurityScope], bookmarkDataIsStale: &isState)
            guard !isState else { return nil }
            return bookmarkDataURL
        } catch {
            print(error)
            return nil
        }
    }
}

extension Array where Element == ReadFolder {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.folderPath == item.folderPath }) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
}
