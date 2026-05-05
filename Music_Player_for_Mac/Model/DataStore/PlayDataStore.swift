//
//  PlayDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import Foundation
import Combine
import AVFoundation

@MainActor
class PlayDataStore: ObservableObject {
    static let shared = PlayDataStore()
//    let notificationRepository = NotificationRepository()
    @Published var playingMusic: Music? = nil
    @Published var seekPosition: Double = 0.0
    @Published var isEditingSeekPosition: Bool = false
    @Published var seekPositionUpdateTimer: Timer?
    @Published var cashedSeekBarSeconds: Double = 0.0
    @Published var isPlaying: Bool = false
    @Published var playMode: PlayMode = .shuffle
    @Published var playGroup: PlayGroup = .music
    @Published var audioEngine: AVAudioEngine = AVAudioEngine()
    @Published var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    @Published var equalizerNode: AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 10)
    @Published var equalizerToggle: Bool = true
    @Published var masterVolume: Float = 1.0
//    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    enum PlayMode: String {
        case shuffle, order, sameRepeat
    }
    
    enum PlayGroup: String {
        case music, artist, album, playlist, folder, favorite
    }
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
//        try? audioSession.setCategory(.playback)
        audioEngine.attach(playerNode)
        audioEngine.attach(equalizerNode)
        audioEngine.connect(playerNode, to: equalizerNode, format: nil)
        audioEngine.connect(equalizerNode, to: audioEngine.mainMixerNode, format: nil)
//        Task {
//            let equalizerParameters = await EqualizerParameterRepository.read()
//            PlayRepository.setEqualizer(equalizerParameters: equalizerParameters)
//        }
//        loadNextMusic()
//        playMode = UserDefaultsRepository.loadPlayMode()
//        notificationRepository.initRemoteCommand()
//        notificationRepository.setNotification()
//        PlayRepository.stop()
    }
    
    
}
