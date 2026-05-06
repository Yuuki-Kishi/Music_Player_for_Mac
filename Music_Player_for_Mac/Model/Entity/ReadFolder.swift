//
//  ReadFolder.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import Foundation

struct ReadFolder: Codable, Hashable, Identifiable, Equatable {
    
    var id = UUID()
    var isRead: Bool
    var folderPath: String
    var bookmarkData: Data
    
    enum CodingKeys: CodingKey {
        case isRead, folderPath, bookmarkData
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)
        self.folderPath = try container.decode(String.self, forKey: .folderPath)
        self.bookmarkData = try container.decode(Data.self, forKey: .bookmarkData)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isRead, forKey: .isRead)
        try container.encode(folderPath, forKey: .folderPath)
        try container.encode(bookmarkData, forKey: .bookmarkData)
    }
    
    init(isRead: Bool, folderPath: String, bookmarkData: Data) {
        self.isRead = isRead
        self.folderPath = folderPath
        self.bookmarkData = bookmarkData
    }
    
    init() {
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
    mutating func remove(readFolder: Element) {
        if let index = self.firstIndex(where: { $0.folderPath == readFolder.folderPath }) {
            self.remove(at: index)
        }
    }
}
