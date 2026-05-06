//
//  MusicView.swift
//  file_Musician_for_Mac
//
//  Created by 岸　優樹 on 2026/02/10.
//

import SwiftUI

struct MusicView: View {
    @StateObject var musicDataStore: MusicDataStore = .shared
    @ObservedObject var readFolderDataStore: ReadFolderDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @State var selection: Set<Music.ID> = []
    
    var body: some View {
        VStack {
            Table(musicDataStore.musicList, selection: $selection) {
                TableColumn("タイトル") { music in
                    MusicViewCell(music: music, column: .musicName)
                }
                .width(min: 30, max: .infinity)
                TableColumn("時間") { music in
                    MusicViewCell(music: music, column: .musicLength)
                }
                .width(60)
                TableColumn("アーティスト") { music in
                    MusicViewCell(music: music, column: .artistName)
                }
                .width(min: 30, max: .infinity)
                TableColumn("アルバム") { music in
                    MusicViewCell(music: music, column: .albumName)
                }
                .width(min: 30, max: .infinity)
                TableColumn("更新日時") { music in
                    MusicViewCell(music: music, column: .editedDate)
                }
                .width(150)
            }
            .frame(minWidth: 250)
            .contextMenu(forSelectionType: Music.ID.self, menu: { _ in }) { musics in
                guard let music = musicDataStore.musicList.first(where: { $0.id == musics.first }) else { return }
                PlayRepository.musicChoosed(music: music, playGroup: .music)
                let filePaths = musicDataStore.musicList.map { $0.fullPath }
                PlayRepository.setNextMusics(fullPaths: filePaths)
            }
            PlayInfoView(playDataStore: playDataStore)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: { loadMusics() }) {
                    Image(systemName: "document.viewfinder")
                }
            }
        }
        .navigationTitle("ミュージック")
        .onAppear() {
            selection = []
            loadMusics()
        }
    }
    func loadMusics() {
        Task {
            musicDataStore.musicList.removeAll()
            await MusicRepository.loadMusics()
            musicDataStore.musicList.sort { $0.musicName < $1.musicName }
        }
    }
}

#Preview {
    MusicView(readFolderDataStore: .shared, playDataStore: .shared)
}
