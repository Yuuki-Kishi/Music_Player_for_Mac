//
//  PlayControlView.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//

import SwiftUI

struct PlayControlView: View {
    @ObservedObject var playDataStore: PlayDataStore
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "list.bullet")
            }
            .buttonStyle(.plain)
            .padding(10)
            Image(systemName: speakerIconString())
                .frame(width: 20)
            Slider(value: $playDataStore.masterVolume, in: 0 ... 1) {
                
            }
            .sliderThumbVisibility(.hidden)
            .frame(width: 70)
            .padding(.trailing, 10)
        }
    }
    func speakerIconString() -> String {
        if playDataStore.masterVolume == 0 {
            return "speaker.slash"
        } else if playDataStore.masterVolume < 1 / 3 {
            return "speaker.wave.1"
        } else if playDataStore.masterVolume < 2 / 3 {
            return "speaker.wave.2"
        } else {
            return "speaker.wave.3"
        }
    }
}

#Preview {
    PlayControlView(playDataStore: .shared)
}
