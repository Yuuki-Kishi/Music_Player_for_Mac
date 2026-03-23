//
//  FolderSettingViewCell.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/12.
//

import SwiftUI

struct ReadFolderViewCell: View {
    @Binding var readFolder: ReadFolder
    @State var column: ColumnEnum
    
    enum ColumnEnum {
        case folderTitle, containMusicCount, isRead, folderPath, removeButton
    }
    
    var body: some View {
        switch column {
        case .folderTitle:
            Text(readFolder.folderTitle)
                .lineLimit(1)
                .foregroundStyle(.primary)
        case .containMusicCount:
            Text(String(readFolder.containMusicCount) + "曲")
                .lineLimit(1)
                .foregroundStyle(.secondary)
        case .isRead:
            Toggle("", isOn: $readFolder.isRead)
                .labelsHidden()
        case .folderPath:
            Text(readFolder.folderPath)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .truncationMode(.head)
        case .removeButton:
            Button(action: {
                
            }, label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(Color("SelectedGray")))
            })
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    ReadFolderViewCell(readFolder: Binding(get: { ReadFolder() }, set: {_ in}), column: .folderTitle)
}
