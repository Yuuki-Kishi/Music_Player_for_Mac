//
//  PlayFlowRepository.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/21.
//

import Foundation

@MainActor
class PlayFlowRepository {
    static let playNextFilePath: String = "System/PlayNext.m3u8"
    static let playBackFilePath: String = "System/PlayBack.m3u8"
    
    //create
    static func createPlayNextM3U8() -> Bool {
        let content = "#EXTM3U\n" + "#PlayNext\n"
        return FileService.createFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func createPlayBackM3U8() -> Bool {
        let content = "#EXTM3U\n" + "#PlayBack\n"
        return FileService.createFileWithString(filePath: playBackFilePath, content: content)
    }
    
    //check
    static func isExistPlayNextM3U8() -> Bool {
        FileService.isExistFileInDocumentDirectory(filePath: playNextFilePath)
    }
    
    static func isExistPlayBackM3U8() -> Bool {
        FileService.isExistFileInDocumentDirectory(filePath: playBackFilePath)
    }
    
    //get
    static func getPlayNextM3U8() -> [String]? {
        do {
            guard let content = try FileService.getFileString(filePath: playNextFilePath) else { return nil }
            return content.components(separatedBy: "\n")
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getNextMusicFilePath() -> String? {
        guard let playNextM3U8 = getPlayNextM3U8() else { return nil }
        return playNextM3U8.first
    }
    
    static func getPlayBackM3U8() -> [String]? {
        do {
            guard let content = try FileService.getFileString(filePath: playBackFilePath) else { return nil }
            return content.components(separatedBy: "\n")
        } catch {
            print(error)
            return nil
        }
    }
    
    //update
    static func addPlayNextM3U8(filePath: String) -> Bool {
        guard var previousContent = getPlayNextM3U8() else { return false }
        previousContent.append(noDuplicate: filePath)
        let content = previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func addPlayBackM3U8(filePath: String) -> Bool {
        guard var previousContent = getPlayBackM3U8() else { return false }
        previousContent.append(noDuplicate: filePath)
        let content = previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playBackFilePath, content: content)
    }
    
    static func writePlayNextM3U8(filePaths: [String]) -> Bool {
        let content = filePaths.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func writePlayBackM3U8(filePaths: [String]) -> Bool {
        let content = filePaths.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playBackFilePath, content: content)
    }
    
    static func removePlayNextM3U8(filePath: String) -> Bool {
        guard var previousContent = getPlayNextM3U8() else { return false }
        previousContent.remove(string: filePath)
        let content = previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func removePlayBackM3U8(filePath: String) -> Bool {
        guard var previousContent = getPlayBackM3U8() else { return false }
        previousContent.remove(string: filePath)
        let content = previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playBackFilePath, content: content)
    }
    
    static func cleanUpPlayNextM3U8() -> Bool {
        FileService.updateFileWithString(filePath: playNextFilePath, content: "")
    }
    
    static func cleanUpPlayBackM3U8() -> Bool {
        FileService.updateFileWithString(filePath: playBackFilePath, content: "")
    }
}
