//
//  ViewDataStore.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/10.
//

import Foundation
import Combine

@MainActor
class ViewDataStore: ObservableObject {
    static let shared = ViewDataStore()
    
    @Published var selectedView: ViewEnum = .musicView
    
    enum ViewEnum {
        case musicView, artistView, albumView, folderView, readFolderView, equalizerView
    }
}
