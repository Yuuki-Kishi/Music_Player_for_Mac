//
//  PlayInfoView.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//

import SwiftUI

struct PlayInfoView: View {
    @ObservedObject var playDataStore: PlayDataStore
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.primary.opacity(0.05))
                .frame(height: 65)
            HStack {
                ButtonsView(playDataStore: playDataStore)
                MusicInfoView(playDataStore: playDataStore)
                PlayControlView(playDataStore: playDataStore)
            }
            .padding(.horizontal)
        }
    }
    
}

#Preview {
    PlayInfoView(playDataStore: .shared)
}
