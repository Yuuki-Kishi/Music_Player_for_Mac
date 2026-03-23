//
//  FileService.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import Foundation
import AVFoundation

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
//    static func getFilePaths(folderPath: String) -> [String] {
//        let folderURL = URL(fileURLWithPath: folderPath)
//        var filePaths: [String] = []
//        do {
//            let bookmarkDataURL = try URL(resolvingBookmarkData: <#T##Data#>, bookmarkDataIsStale: &<#T##Bool#>)
//            guard folderURL.startAccessingSecurityScopedResource() else {
//                print("Failed to access the directory")
//                return []
//            }
//            defer { folderURL.stopAccessingSecurityScopedResource() }
//            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
//            print(fileURLs)
//            for fileURL in fileURLs {
//                if fileURL.planePath.contains("/.Trash/") || fileURL.planePath.contains("/Playlist/") { continue }
//                let path = fileURL.planePath.replacingOccurrences(of: folderURL.planePath, with: "")
//                let filePath = path.replacingOccurrences(of: "/private", with: "")
//                filePaths.append(filePath)
//            }
//        } catch {
//            print(error)
//        }
//        return filePaths
//    }
    
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
    
    static func getFileMetadataInReadFolder(filePath: String, readFolder: ReadFolder) async -> Music? {
        do {
            guard let bookmarkDataURL = readFolder.bookmarkDataURL else { return nil }
            let fileURL = bookmarkDataURL.appending(path: filePath)
            guard bookmarkDataURL.startAccessingSecurityScopedResource() else { return nil }
            defer { bookmarkDataURL.stopAccessingSecurityScopedResource() }
            let asset = AVURLAsset(url: fileURL)
            guard let metadata = try? await asset.load(.commonMetadata) else { return nil }
            let musicName = try? await metadata.first(where: { $0.commonKey == .commonKeyTitle })?.load(.stringValue)
            let artistName = try? await metadata.first(where: { $0.commonKey == .commonKeyArtist })?.load(.stringValue)
            let albumName = try? await metadata.first(where: { $0.commonKey == .commonKeyAlbumName })?.load(.stringValue)
            let coverImage = try? await metadata.first(where: { $0.commonKey == .commonKeyArtwork })?.load(.dataValue)
            let folderPath = URL(filePath: filePath).deletingLastPathComponent().planePath
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useAll]
            bcf.countStyle = .file
            let attributes: [FileAttributeKey: Any] = try fileManager.attributesOfItem(atPath: fileURL.planePath)
            guard let editedDate = attributes[FileAttributeKey.modificationDate] as? Date else { return nil }
            guard let bytes = attributes[.size] as? Int64 else { return nil }
            let fileSize = bcf.string(fromByteCount: bytes)
            let musicLength = try await CMTimeGetSeconds(asset.load(.duration))
            let music = Music(musicName: musicName, artistName: artistName, albumName: albumName, coverImage: coverImage, editedDate: editedDate, fileSize: fileSize, musicLength: musicLength, parentFolderPath: folderPath, readFolder: readFolder, filePath: filePath)
            return music
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getFileCount(folderURL: URL) -> Int {
        let fileURLs = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: [])
        var containMusicCount: Int = 0
        while let fileURL = fileURLs?.nextObject() as? URL {
            if !fileURL.isMusicFile { continue }
            let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey])
            if resourceValues?.isDirectory == true { continue }
            containMusicCount += 1
        }
        return containMusicCount
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
