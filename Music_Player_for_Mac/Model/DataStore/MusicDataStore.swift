//
//  MusicDataStore.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/10.
//

import Foundation
import Combine

@MainActor
class MusicDataStore: ObservableObject {
    static let shared = MusicDataStore()
    
    @Published var musicList: [Music] = []
    @Published var selectedMusic: Music? = nil
}
