//
//  FileService.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import Foundation
import AVFoundation

@MainActor
class FileService {
    static let fileManager = FileManager.default
    static let documentDirectory: URL? = { fileManager.urls(for: .documentDirectory, in: .userDomainMask).first }()
    
    //create
    static func createFileInDocumentDirectory(filePath: String, content: String) -> Bool {
        guard let fileURL = documentDirectory?.appending(path: filePath) else { return false }
        guard let data = content.data(using: .utf8) else { return false }
        return fileManager.createFile(atPath: fileURL.planePath, contents: data)
    }
    
    static func createDirectoryInDocumentDirectory(folderPath: String) -> Bool {
        guard let folderURL = documentDirectory?.appending(path: folderPath) else { return false }
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    //check
    static func isExistFileInDocumentDirectory(filePath: String) -> Bool {
        guard let fileURL = documentDirectory?.appending(path: filePath) else { return false }
        return fileManager.fileExists(atPath: fileURL.planePath)
    }
    
//    static func isExistFile(filePath: String) -> Bool {
//        fileManager.fileExists(atPath: filePath)
//    }
    
//    static func isExistDirectory(folderPath: String) -> Bool {
//        fileManager.fileExists(atPath: folderPath)
//    }
    
    //get
    
//    static func getPlaylistFilePaths() -> [String] {
//        guard let folderURL = documentDirectory?.appendingPathComponent("Playlist") else { return [] }
//        var filePaths: [String] = []
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil).filter { $0.planePath.contains(".m3u8") }
//            for fileURL in fileURLs {
//                if fileURL.planePath.contains("/.Trash/") { continue }
//                let path = fileURL.planePath.replacingOccurrences(of: folderURL.planePath, with: "")
//                let filePath = path.replacingOccurrences(of: "/private", with: "")
//                filePaths.append(filePath)
//            }
//        } catch {
//            print(error)
//        }
//        return filePaths
//    }
    
    static func getAllFilePaths(readFolder: ReadFolder) -> [String] {
        guard let bookmarkDataURL = readFolder.bookmarkDataURL else { return [] }
        guard bookmarkDataURL.startAccessingSecurityScopedResource() else { return [] }
        defer { bookmarkDataURL.stopAccessingSecurityScopedResource() }
        let fileURLs = fileManager.enumerator(at: bookmarkDataURL, includingPropertiesForKeys: [])
        var filePaths: [String] = []
        while let fileURL = fileURLs?.nextObject() as? URL {
            if !fileURL.isMusicFile { continue }
            let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey])
            if resourceValues?.isDirectory == true { continue }
            let path = fileURL.planePath.replacingOccurrences(of: bookmarkDataURL.planePath, with: "")
            let filePath = path.replacingOccurrences(of: "/private", with: "")
            filePaths.append(filePath)
        }
        return filePaths
    }
    
    static func getFileContentInDocumentDirectory(filePath: String) -> String? {
        guard let fileURL = documentDirectory?.appending(path: filePath) else { return nil }
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getFileAttributes(filePath: String) -> [FileAttributeKey : Any]? {
        do {
            return try fileManager.attributesOfItem(atPath: filePath)
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getFileCount(readFolder: ReadFolder) -> Int {
        getAllFilePaths(readFolder: readFolder).count
    }
    
//    static func getFolderPath(filePath: String) -> String {
//        URL(fileURLWithPath: filePath).deletingLastPathComponent().planePath
//    }
    
    static func getFolderName(folderPath: String) -> String {
        URL(filePath: folderPath).lastPathComponent
    }
    
    //update
    static func addRowToFile(filePath: String, content: String) -> Bool {
        guard let fileContent = getFileContentInDocumentDirectory(filePath: filePath) else { return false }
        let newContent = fileContent + content
        return updateFileInDocumentDirectory(filePath: filePath, content: newContent)
    }
    
    static func updateFileInDocumentDirectory(filePath: String, content: String) -> Bool {
        guard let fileURL = documentDirectory?.appending(path: filePath) else { return false }
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
//    static func renameFile(filePath: String, newFilePath: String) -> Bool {
//        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
//        guard let newFileURL = documentDirectory?.appendingPathComponent(newFilePath) else { return false }
//        do {
//            try fileManager.moveItem(at: fileURL, to: newFileURL)
//            return true
//        } catch {
//            print(error)
//        }
//        return false
//    }
    
    //delete
//    static func fileDelete(filePath: String) -> Bool {
//        guard isExistFile(filePath: filePath) else { return false }
//        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
//        do {
//            try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
//            return true
//        } catch {
//            print(error)
//        }
//        return false
//    }
}

extension URL {
    var planePath: String {
        self.path(percentEncoded: false)
    }
    var isMusicFile: Bool {
        let isTrashed = self.planePath.contains("/.Trash")
        let isPlaylist = self.planePath.contains("/playlist")
        let isSystem = self.planePath.contains("/System")
        let isM3U8 = self.planePath.contains(".m3u8")
        let isDSStore = self.planePath.contains(".DS_Store")
        return !isTrashed && !isPlaylist && !isSystem && !isM3U8 && !isDSStore
    }
}
