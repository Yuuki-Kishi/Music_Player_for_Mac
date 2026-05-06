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
    static let playNextMetaInfo: String = "#EXTM3U\n" + "#PlayNext"
    static let playBackFilePath: String = "System/PlayBack.m3u8"
    static let playBackMetaInfo: String = "#EXTM3U\n" + "#PlayBack"
    
    //create
    static func createPlayNextM3U8() -> Bool {
        FileService.createFileWithString(filePath: playNextFilePath, content: playNextMetaInfo)
    }
    
    static func createPlayBackM3U8() -> Bool {
        FileService.createFileWithString(filePath: playBackFilePath, content: playBackMetaInfo)
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
            guard let M3U8Text = try FileService.getFileString(filePath: playNextFilePath) else { return nil }
            var content = M3U8Text.components(separatedBy: "\n")
            content.removeFirst(2)
            return content
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
            guard let M3U8Text = try FileService.getFileString(filePath: playBackFilePath) else { return nil }
            var content = M3U8Text.components(separatedBy: "\n")
            content.removeFirst(2)
            return content
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getLastMusicFilePath() -> String? {
        guard let playBackM3U8 = getPlayBackM3U8() else { return nil }
        return playBackM3U8.last
    }
    
    //update
    static func addPlayNextM3U8(filePath: String, at: Int) -> Bool {
        guard let at = getPlayNextM3U8()?.count else { return false }
        return insertPlayNextM3U8(filePath: filePath, at: at)
    }
    
    static func addPlayBackM3U8(filePath: String) -> Bool {
        guard let at = getPlayBackM3U8()?.count else { return false }
        return insertPlayBackM3U8(filePath: filePath, at: at)
    }
    
    static func insertPlayNextM3U8(filePath: String, at: Int) -> Bool {
        guard var previousContent = getPlayNextM3U8() else { return false }
        previousContent.insert(filePath, at: at)
        let content = playNextMetaInfo + "\n" + previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func insertPlayBackM3U8(filePath: String, at: Int) -> Bool {
        guard var previousContent = getPlayBackM3U8() else { return false }
        previousContent.insert(filePath, at: at)
        let content = playBackMetaInfo + "\n" + previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playBackFilePath, content: content)
    }
    
    static func writePlayNextM3U8(filePaths: [String]) -> Bool {
        let content = playNextMetaInfo + "\n" + filePaths.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func writePlayBackM3U8(filePaths: [String]) -> Bool {
        let content = playBackMetaInfo + "\n" + filePaths.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playBackFilePath, content: content)
    }
    
    static func removePlayNextM3U8(filePath: String) -> Bool {
        guard var previousContent = getPlayNextM3U8() else { return false }
        previousContent.remove(string: filePath)
        let content = playNextMetaInfo + "\n" + previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playNextFilePath, content: content)
    }
    
    static func removePlayBackM3U8(filePath: String) -> Bool {
        guard var previousContent = getPlayBackM3U8() else { return false }
        previousContent.remove(string: filePath)
        let content = playBackMetaInfo + "\n" + previousContent.joined(separator: "\n")
        return FileService.updateFileWithString(filePath: playBackFilePath, content: content)
    }
    
    static func cleanUpPlayNextM3U8() -> Bool {
        FileService.updateFileWithString(filePath: playNextFilePath, content: playNextMetaInfo)
    }
    
    static func cleanUpPlayBackM3U8() -> Bool {
        FileService.updateFileWithString(filePath: playBackFilePath, content: playBackMetaInfo)
    }
}
