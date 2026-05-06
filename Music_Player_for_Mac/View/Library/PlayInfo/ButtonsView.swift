//
//  ButtonsView.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//

import SwiftUI

struct ButtonsView: View {
    @ObservedObject var playDataStore: PlayDataStore
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: playModeString())
                    .font(.system(size: 15))
            }
            .buttonStyle(.plain)
            .padding(10)
            Button(action: {
                
            }) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
            .padding(.vertical)
            Button(action: {
                playButtonAction()
            }) {
                Image(systemName: playIconString())
                    .font(.system(size: 30))
            }
            .buttonStyle(.plain)
            .padding()
            Button(action: {
                
            }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
            .padding(.vertical)
            .padding(.trailing, 10)
        }
    }
    func playModeString() -> String {
        switch playDataStore.playMode {
        case .shuffle:
            return "shuffle"
        case .order:
            return "repeat"
        case .sameRepeat:
            return "repeat.1"
        }
    }
    func playButtonAction() {
        if playDataStore.isPlaying {
            PlayRepository.pause()
        } else {
            PlayRepository.play()
        }
    }
    func playIconString() -> String {
        if playDataStore.isPlaying {
            return "pause.fill"
        } else {
            return "play.fill"
        }
    }
}

#Preview {
    ButtonsView(playDataStore: .shared)
}
