//
//  MusicRepository.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/03/27.
//

import Foundation
import AVFoundation

@MainActor
class MusicRepository {
    static let musicDataStore: MusicDataStore = .shared
    static let readFolderDataStore: ReadFolderDataStore = .shared
    
    //create
    
    //check
    
    //get
    static func getMusic(filePath: String, readFolder: ReadFolder) async -> Music? {
        do {
            guard let bookmarkDataURL = readFolder.bookmarkDataURL else { return nil }
            let fileURL = bookmarkDataURL.appending(path: filePath)
            guard bookmarkDataURL.startAccessingSecurityScopedResource() else { return nil }
            defer { bookmarkDataURL.stopAccessingSecurityScopedResource() }
            let asset = AVURLAsset(url: fileURL)
            guard let metadata = try? await asset.load(.commonMetadata) else { return nil }
            let musicName = try await metadata.first(where: { $0.commonKey == .commonKeyTitle })?.load(.stringValue)
            let artistName = try await metadata.first(where: { $0.commonKey == .commonKeyArtist })?.load(.stringValue)
            let albumName = try await metadata.first(where: { $0.commonKey == .commonKeyAlbumName })?.load(.stringValue)
            let coverImage = try await metadata.first(where: { $0.commonKey == .commonKeyArtwork })?.load(.dataValue)
            let folderPath = URL(filePath: filePath).deletingLastPathComponent().planePath
            guard let attributes = FileService.getFileAttributes(filePath: fileURL.planePath) else { return nil }
            guard let editedDate = attributes[FileAttributeKey.modificationDate] as? Date else { return nil }
            guard let bytes = attributes[.size] as? Int64 else { return nil }
            let byteCountFormatter = ByteCountFormatter()
            byteCountFormatter.allowedUnits = [.useAll]
            byteCountFormatter.countStyle = .file
            let fileSize = byteCountFormatter.string(fromByteCount: bytes)
            let musicLength = try await CMTimeGetSeconds(asset.load(.duration))
            let music = Music(musicName: musicName, artistName: artistName, albumName: albumName, coverImage: coverImage, editedDate: editedDate, fileSize: fileSize, musicLength: musicLength, parentFolderPath: folderPath, readFolder: readFolder, filePath: filePath)
            return music
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getMusics(readFolder: ReadFolder) async -> [Music] {
        var musics: [Music] = []
        let filePaths = FileService.getAllFilePaths(readFolder: readFolder)
        for filePath in filePaths {
            guard let music = await getMusic(filePath: filePath, readFolder: readFolder) else { continue }
            musics.append(noDuplicate: music)
        }
        return musics
    }
    
    static func loadMusics() async {
        for readFolder in readFolderDataStore.readFolderList {
            if !readFolder.isRead { continue }
            let musics = await getMusics(readFolder: readFolder)
            musicDataStore.musicList = musicDataStore.musicList + musics
        }
    }
    
    //update
    
    //delete
}
