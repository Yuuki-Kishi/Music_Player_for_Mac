//
//  FolderSettingView.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import SwiftUI

struct ReadFolderView: View {
    @ObservedObject var readFolderDataStore: ReadFolderDataStore
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    openSelectPanel()
                }, label: {
                    Label("フォルダを選択", systemImage: "arrow.up.right.square")
                        .padding(5)
                })
                .padding()
            }
            Table($readFolderDataStore.readFolderList) {
                TableColumn("フォルダ名") { readFolder in
                    ReadFolderViewCell(readFolder: readFolder, column: .folderTitle)
                }
                TableColumn("曲数") { readFolder in
                    ReadFolderViewCell(readFolder: readFolder, column: .containMusicCount)
                }
                .width(60)
                TableColumn("読み込み") { readFolder in
                    ReadFolderViewCell(readFolder: readFolder, column: .isRead)
                }
                .width(60)
                TableColumn("フォルダパス") { readFolder in
                    ReadFolderViewCell(readFolder: readFolder, column: .folderPath)
                }
                TableColumn("削除") { readFolder in
                    ReadFolderViewCell(readFolder: readFolder, column: .removeButton)
                }
                .width(50)
            }
        }
        .navigationTitle("フォルダ設定")
    }
    func openSelectPanel() {
        let panel = selectFolderPanel()
        if panel.runModal() == .OK {
            do {
                
            } catch {
                print(error)
            }
        }
    }
    func selectFolderPanel() -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.message = "フォルダを選択してください"
        return openPanel
    }
}

#Preview {
    ReadFolderView(readFolderDataStore: .shared)
}
