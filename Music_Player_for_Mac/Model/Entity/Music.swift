//
//  Music.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/10.
//

import Foundation

struct Music: Hashable, Identifiable, Equatable {
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.filePath == rhs.filePath
    }
    
    var id = UUID()
    var musicName: String
    var artistName: String
    var albumName: String
    var coverImage: Data
    var editedDate: Date
    var fileSize: String
    var musicLength: TimeInterval
    var parentFolderPath: String
    var readFolder: ReadFolder
    var filePath: String
    
    init(musicName: String, artistName: String, albumName: String, coverImage: Data, editedDate: Date, fileSize: String, musicLength: TimeInterval, parentFolderPath: String, readFolder: ReadFolder, filePath: String) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.coverImage = coverImage
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.parentFolderPath = parentFolderPath
        self.readFolder = readFolder
        self.filePath = filePath
    }
    
    init(musicName: String?, artistName: String?, albumName: String?, coverImage: Data?, editedDate: Date?, fileSize: String?, musicLength: TimeInterval?, parentFolderPath: String?, readFolder: ReadFolder?, filePath: String?) {
        self.musicName = musicName ?? "不明な曲"
        self.artistName = artistName ?? "不明なアーティスト"
        self.albumName = albumName ?? "不明なアルバム"
        self.coverImage = coverImage ?? Data()
        self.editedDate = editedDate ?? Date()
        self.fileSize = fileSize ?? "0MB"
        self.musicLength = musicLength ?? 0.0
        self.parentFolderPath = parentFolderPath ?? "unknownParentFolderPath"
        self.readFolder = readFolder ?? ReadFolder()
        self.filePath = filePath ?? "unknownFilePath"
    }
    
    init() {
        self.musicName = "不明な曲"
        self.artistName = "不明なアーティスト"
        self.albumName = "不明なアルバム"
        self.coverImage = Data()
        self.editedDate = Date()
        self.fileSize = "0MB"
        self.musicLength = 0.0
        self.parentFolderPath = "unknownParentFolderPath"
        self.readFolder = ReadFolder()
        self.filePath = "unknownFilePath"
    }
}

extension Music {
    var fullPath: String {
        self.readFolder.folderPath + "/" + self.filePath
    }
}

extension Array where Element == Music {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.filePath == item.filePath }) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
}
