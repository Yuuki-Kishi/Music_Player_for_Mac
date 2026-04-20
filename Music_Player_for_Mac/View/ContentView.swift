//
//  ContentView.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/03/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewDataStore: ViewDataStore = .shared
        @StateObject var readFolderDataStore: ReadFolderDataStore = .shared
        @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

        var body: some View {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SideBarView(viewDataStore: viewDataStore)
            } detail: {
                switch viewDataStore.selectedView {
                case .musicView:
                    MusicView(readFolderDataStore: readFolderDataStore)
                case .artistView:
                    EmptyView()
                case .albumView:
                    EmptyView()
                case .folderView:
                    EmptyView()
                case .readFolderView:
                    ReadFolderView(readFolderDataStore: readFolderDataStore)
                case .equalizerView:
                    EqualizerView()
                }
            }
            .onAppear() {
                onAppear()
            }
        }
        func onAppear() {
            print("rootFolderPath:", FileService.documentDirectory?.path() ?? "nil")
            if !FileService.createDirectoryInDocumentDirectory(folderPath: "Playlist") { print("Failed create Playlist directory") }
            if !FileService.createDirectoryInDocumentDirectory(folderPath: "System") { print("Failed create System directory") }
            if !ReadFolderRepository.isExistReadFolderJson() {
                if !ReadFolderRepository.createReadFolderJson() { print("Failed create ReadFolder.json") }
            }
            readFolderDataStore.readFolderList = ReadFolderRepository.getReadFolder()
        }
}

#Preview {
    ContentView()
}
