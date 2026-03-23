//
//  ReadFolderDataStore.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import Foundation
import Combine

@MainActor
class ReadFolderDataStore: ObservableObject {
    static let shared = ReadFolderDataStore()
    
    @Published var readFolderList: [ReadFolder] = []
}
