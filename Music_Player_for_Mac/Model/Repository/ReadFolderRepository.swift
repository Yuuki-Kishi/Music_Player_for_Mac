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
    static let readFolderCSVFilePath: String = "System/ReadFolder.csv"
    static let readFolderDataStore: ReadFolderDataStore = .shared
    
    //create
    static func createReadFolderCSVData() -> Bool {
        let header: [String] = ["isRead", "folderPath", "bookmarkData"]
        let containData = header.joined(separator: ",") + "\n"
        return FileService.createFileInDocumentDirectory(filePath: readFolderCSVFilePath, content: containData)
    }
    
    //get
    static func getReadFolderCSVData() -> [ReadFolder] {
        do {
            guard let csvURL = FileService.documentDirectory?.appending(path: readFolderCSVFilePath) else { return [] }
            let csvData = try CSV<Named>(url: csvURL)
            var readFolderList: [ReadFolder] = []
            for row in csvData.rows {
                guard let isReadString = row["isRead"] else { continue }
                guard let isRead = Bool(isReadString.lowercased()) else { continue }
                guard let folderPath = row["folderPath"] else { continue }
                guard let bookmarkDataString = row["bookmarkData"] else { continue }
                guard let bookmarkData = Data(base64Encoded: bookmarkDataString) else { continue }
                let readFolder = ReadFolder(isRead: isRead, folderPath: folderPath, bookmarkData: bookmarkData)
                readFolderList.append(noDuplicate: readFolder)
            }
            return readFolderList
        } catch {
            print(error)
            return []
        }
    }
    
    //update
    static func addReadFolder(readFolder: ReadFolder) -> Bool {
        let csvData: [String] = [readFolder.isRead.description.uppercased(), readFolder.folderPath, readFolder.bookmarkData.base64EncodedString()]
        let csvString = csvData.joined(separator: ",") + "\n"
        guard FileService.addRowToFile(filePath: readFolderCSVFilePath, content: csvString) else { return false }
        readFolderDataStore.readFolderList.append(noDuplicate: readFolder)
        return true
    }
    
    //delete
    static func deleteReadFolder(readFolder: ReadFolder) -> Bool {
        var currentReadFolder = getReadFolderCSVData()
        currentReadFolder.remove(readFolder: readFolder)
        let header: [String] = ["isRead", "folderPath", "bookmarkData"]
        var csvData: [String] = [header.joined(separator: ",")]
        for readFolder in currentReadFolder {
            let data: [String] = [readFolder.isRead.description.uppercased(), readFolder.folderPath, readFolder.bookmarkData.base64EncodedString()]
            csvData.append(data.joined(separator: ","))
        }
        let csvString = csvData.joined(separator: "\n") + "\n"
        guard FileService.updateFileInDocumentDirectory(filePath: readFolderCSVFilePath, content: csvString) else { return false }
        readFolderDataStore.readFolderList.remove(readFolder: readFolder)
        return true
    }
}
