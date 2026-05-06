//
//  MusicInfoView.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//

import SwiftUI

struct MusicInfoView: View {
    @ObservedObject var playDataStore: PlayDataStore
    
    var body: some View {
        VStack {
            HStack {
                coverImage()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack {
                    Text(musicNameString())
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 15))
                    Text(artistAndAlbumNameString())
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 11))
                }
                musicMenu()
            }
            HStack {
                Text(secondToTime(second: playDataStore.seekPosition))
                    .foregroundStyle(.secondary)
                    .font(.system(size: 10))
                    .padding(.horizontal, 5)
                Spacer()
                Text(secondToTime(second: playDataStore.playingMusic?.musicLength ?? 0))
                    .foregroundStyle(.secondary)
                    .font(.system(size: 10))
                    .padding(.horizontal, 5)
            }
            Slider(value: $playDataStore.seekPosition, in: 0 ... (playDataStore.playingMusic?.musicLength ?? 300)) { isEditing in
                playDataStore.isEditingSeekPosition = isEditing
                if !isEditing {
                    PlayRepository.setSeek()
                }
            }
            .sliderThumbVisibility(.hidden)
            .padding(.bottom, 3)
        }
    }
    func coverImage() -> some View {
        if let imageData = playDataStore.playingMusic?.coverImage {
            if let image = NSImage(data: imageData) {
                return Image(nsImage: image)
            }
        }
        return Image(systemName: "music.note")
    }
    func musicNameString() -> String {
        playDataStore.playingMusic?.musicName ?? "不明な曲"
    }
    func artistAndAlbumNameString() -> String {
        let artistName = playDataStore.playingMusic?.artistName ?? "不明なアーティスト"
        let albumName = playDataStore.playingMusic?.albumName ?? "不明なアルバム"
        return artistName + " - " + albumName
    }
    func musicMenu() -> some View {
        Menu {
            Button(action: {}) {
                Label("情報を見る", systemImage: "info.circle")
            }
        } label: {
            Image(systemName: "ellipsis")
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
        .menuIndicator(.hidden)
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    func secondToTime(second: TimeInterval) -> String {
        let second = Int(second)
        return String(format: "%02d:%02d:%02d", second / 3600, (second % 3600) / 60, (second % 3600) % 60)
    }
}

#Preview {
    MusicInfoView(playDataStore: .shared)
}
