//
//  SideBarView.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/10.
//

import SwiftUI

struct SideBarView: View {
    @ObservedObject var viewDataStore: ViewDataStore
    
    var body: some View {
        List {
            Section(content: {
                SideBarViewCell(viewDataStore: viewDataStore, viewType: .musicView)
                SideBarViewCell(viewDataStore: viewDataStore, viewType: .artistView)
                SideBarViewCell(viewDataStore: viewDataStore, viewType: .albumView)
                SideBarViewCell(viewDataStore: viewDataStore, viewType: .folderView)
            }, header: {
                Text("ライブラリ")
            })
            Section(content: {
                SideBarViewCell(viewDataStore: viewDataStore, viewType: .readFolderView)
                SideBarViewCell(viewDataStore: viewDataStore, viewType: .equalizerView)
            }, header: {
                Text("設定")
            })
        }
    }
}

#Preview {
    SideBarView(viewDataStore: .shared)
}
