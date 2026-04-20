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
        case isRead, musicCount, folderPath, removeButton
    }
    
    var body: some View {
        switch column {
        case .isRead:
            Toggle("", isOn: $readFolder.isRead)
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .center)
        case .musicCount:
            Text(musicCount())
                .lineLimit(1)
                .foregroundStyle(.primary)
        case .folderPath:
            Text(readFolder.folderPath)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .truncationMode(.head)
        case .removeButton:
            Button(action: {
                guard ReadFolderRepository.deleteReadFolder(readFolder: readFolder) else { return }
                print("Sucess")
            }, label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
                    .padding(5)
            })
            .buttonStyle(.borderless)
        }
    }
    func musicCount() -> String {
        let musicCount = FileService.getFileCount(readFolder: readFolder)
        return String(musicCount) + "曲"
    }
}

#Preview {
    ReadFolderViewCell(readFolder: Binding(get: { ReadFolder() }, set: {_ in}), column: .folderPath)
}
