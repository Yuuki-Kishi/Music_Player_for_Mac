//
//  SideBarViewCell.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/10.
//

import SwiftUI

struct SideBarViewCell: View {
    @ObservedObject var viewDataStore: ViewDataStore
    @State var viewType: ViewDataStore.ViewEnum
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(backgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                Image(systemName: imageName())
                    .foregroundStyle(color())
                Text(title())
                    .foregroundStyle(color())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(7.5)
        }
        .onTapGesture {
            viewDataStore.selectedView = viewType
        }
    }
    func imageName() -> String {
        switch viewType {
        case .musicView:
            return "music.note"
        case .artistView:
            return "music.microphone"
        case .albumView:
            return "square.stack"
        case .folderView:
            return "folder"
        case .readFolderView:
            return "folder.badge.gearshape"
        case .equalizerView:
            return "slider.horizontal.3"
        }
    }
    func title() -> String {
        switch viewType {
        case .musicView:
            return "ミュージック"
        case .artistView:
            return "アーティスト"
        case .albumView:
            return "アルバム"
        case .folderView:
            return "フォルダ"
        case .readFolderView:
            return "フォルダ設定"
        case .equalizerView:
            return "イコライザ設定"
        }
    }
    func color() -> Color {
        viewDataStore.selectedView == viewType ? .purple : .primary
    }
    func backgroundColor() -> Color {
        viewDataStore.selectedView == viewType ? .secondary : .clear
    }
}

#Preview {
    SideBarViewCell(viewDataStore: .shared, viewType: .musicView)
}
