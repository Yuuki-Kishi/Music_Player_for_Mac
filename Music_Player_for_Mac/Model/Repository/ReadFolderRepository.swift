//
//  ReadFolderRepository.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/13.
//

import Foundation
import SwiftCSV

@MainActor
class ReadFolderRepository {
    static let readFolderCSVFilePath: String = "System/ReadFolder.json"
    static let readFolderDataStore: ReadFolderDataStore = .shared
    
    //create
    static func createReadFolderJson() -> Bool {
        do {
            let emptyData: [ReadFolder] = []
            let content = try JSONEncoder().encode(emptyData)
            return FileService.createFileInDocumentDirectory(filePath: readFolderCSVFilePath, content: content)
        } catch {
            return false
        }
    }
    
    //check
    static func isExistReadFolderJson() -> Bool {
        return FileService.isExistFileInDocumentDirectory(filePath: readFolderCSVFilePath)
    }
    
    //get
    static func getReadFolder() -> [ReadFolder] {
        do {
            guard let jsonData = try FileService.getFileData(filePath: readFolderCSVFilePath) else { return [] }
            return try JSONDecoder().decode([ReadFolder].self, from: jsonData)
        } catch {
            print(error)
            return []
        }
    }
    
    //update
    static func addReadFolder(readFolder: ReadFolder) -> Bool {
        do {
            var readFolders = getReadFolder()
            readFolders.append(noDuplicate: readFolder)
            let content = try JSONEncoder().encode(readFolders)
            guard FileService.updateFileWithData(filePath: readFolderCSVFilePath, content: content) else { return false }
            readFolderDataStore.readFolderList.append(noDuplicate: readFolder)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    //delete
    static func deleteReadFolder(readFolder: ReadFolder) -> Bool {
        do {
            var readFolders = getReadFolder()
            readFolders.remove(readFolder: readFolder)
            let content = try JSONEncoder().encode(readFolders)
            guard FileService.updateFileWithData(filePath: readFolderCSVFilePath, content: content) else { return false }
            readFolderDataStore.readFolderList.remove(readFolder: readFolder)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
