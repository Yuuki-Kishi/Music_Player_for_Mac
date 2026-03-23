//
//  MusicViewCell.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/11.
//

import SwiftUI

struct MusicViewCell: View {
    @State var music: Music
    @State var column: ColumnEnum
    
    enum ColumnEnum {
        case musicName, musicLength, artistName, albumName, editedDate
    }
    
    var body: some View {
        switch column {
            case .musicName:
            Text(music.musicName)
        case .musicLength:
            Text(musicLength())
        case .artistName:
            Text(music.artistName)
        case .albumName:
            Text(music.albumName)
        case .editedDate:
            Text(editedDate())
        }
    }
    func musicLength() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: music.musicLength) ?? "00:00:00"
    }
    func editedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(for: music.editedDate) ?? "----/--/-- --:--:--"
    }
}

#Preview {
    MusicViewCell(music: Music(), column: .musicName)
}
