//
//  PlayRepository.swift
//  Music_Player_for_Mac
//
//  Created by 岸　優樹 on 2026/04/23.
//

import Foundation
import AVFoundation

@MainActor
class PlayRepository {
    static let playDataStore: PlayDataStore = .shared
    static let readFolderDataStore: ReadFolderDataStore = .shared
    
    static func setMusic(music: Music) {
        playDataStore.playingMusic = music
    }
    
    static func setScheduleFile() {
        //currentItem.itemはMPMediaItemクラス
        do {
            guard let bookmarkDataURL = playDataStore.playingMusic?.readFolder.bookmarkDataURL else { return }
            guard bookmarkDataURL.startAccessingSecurityScopedResource() else { return }
            defer { bookmarkDataURL.stopAccessingSecurityScopedResource() }
            guard let fullPath = playDataStore.playingMusic?.fullPath else { return }
            let fileURL = URL(fileURLWithPath: fullPath)
            // Source fileを取得する
            let audioFile = try AVAudioFile(forReading: fileURL)
            // PlayerNodeからAudioEngineのoutput先であるmainMixerNodeへ接続する
            playDataStore.audioEngine.connect(playDataStore.playerNode, to: playDataStore.equalizerNode, format: nil)
            playDataStore.audioEngine.connect(playDataStore.equalizerNode, to: playDataStore.audioEngine.mainMixerNode, format: nil)
            playDataStore.audioEngine.mainMixerNode.outputVolume = playDataStore.masterVolume * 2
            // 再生準備
            playDataStore.playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered)
        }
        catch let error {
            print(error.localizedDescription)
            return
        }
    }
    
    static func setTimer() {
        playDataStore.seekPositionUpdateTimer?.invalidate()
        playDataStore.seekPositionUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSeekPosition), userInfo: nil, repeats: true)
    }
    
    @objc static func updateSeekPosition() {
        // 最後にサンプリングしたデータを取得する
        guard let nodeTime = playDataStore.playerNode.lastRenderTime else { return }
        // playerNodeの時間軸に変換する
        guard let playerTime = playDataStore.playerNode.playerTime(forNodeTime: nodeTime) else { return }
        // サンプルレートとサンプルタイム取得する
        let sampleRate = playerTime.sampleRate
        let sampleTime = playerTime.sampleTime
        // 秒数を取得し保持する
        let currentTime = Double(sampleTime) / sampleRate + playDataStore.cashedSeekBarSeconds
        isEndOfFile(currentTime: currentTime)
        playDataStore.seekPosition = currentTime
    }
    
    static func isEndOfFile(currentTime: Double) {
        //ファイルの長さ
        let fileDuration = Double(playDataStore.playingMusic?.musicLength ?? 300)
        if currentTime >= fileDuration {
            moveNextMusic()
        }
    }
    
    static func play() {
        // 再生処理
        do {
//            try audioSession.setActive(true, options: [])
            try playDataStore.audioEngine.start()
            playDataStore.playerNode.play()
//            notificationRepository.setNowPlayingInfo()
            playDataStore.isPlaying = true
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func pause() {
        playDataStore.isPlaying = false
        playDataStore.audioEngine.pause()
        playDataStore.playerNode.pause()
//        notificationRepository.setNowPlayingInfo()
    }
    
    static func stop() {
        playDataStore.isPlaying = false
        playDataStore.audioEngine.stop()
        playDataStore.playerNode.stop()
    }
    
//    static func loadNextMusic() {
//        Task {
//            if let playingMusicFilePath = UserDefaultsRepository.loadPlayingMusicFilePath() {
//                if FileService.isExistFile(filePath: playingMusicFilePath) {
//                    let music = await FileService.getFileMetadata(filePath: playingMusicFilePath)
//                    setMusic(music: music)
//                    setScheduleFile()
//                    setTimer()
//                    return
//                } else {
//                    if let music = await WillPlayRepository.nextMusic() {
//                        setMusic(music: music)
//                        setScheduleFile()
//                        setTimer()
//                        return
//                    }
//                }
//            }
//            self.playingMusic = nil
//        }
//    }
    
    static func moveNextMusic() {
        stop()
        playDataStore.seekPosition = 0.0
        playDataStore.cashedSeekBarSeconds = 0.0
        switch playDataStore.playMode {
        case .shuffle:
            Task {
                guard let playingMusicFilePath = playDataStore.playingMusic?.fullPath else { return }
                guard PlayFlowRepository.addPlayBackM3U8(filePath: playingMusicFilePath) else { return }
                print("addSucceeded")
                if let nextMusicFilePath = PlayFlowRepository.getNextMusicFilePath() {
                    guard PlayFlowRepository.removePlayNextM3U8(filePath: nextMusicFilePath) else { return }
                    print("removeSucceeded")
                    guard let readFolder = readFolderDataStore.readFolderList.get(fullPath: nextMusicFilePath) else { return }
                    guard let nextMusic = await MusicRepository.getMusic(filePath: nextMusicFilePath, readFolder: readFolder) else { return }
                    musicChoosed(music: nextMusic, playGroup: playDataStore.playGroup)
                } else {
                    playDataStore.seekPosition = 0.0
                    playDataStore.playingMusic = nil
                }
            }
        case .order:
            Task {
                guard let playingMusicFilePath = playDataStore.playingMusic?.fullPath else { return }
                guard PlayFlowRepository.addPlayBackM3U8(filePath: playingMusicFilePath) else { return }
                print("addSucceeded")
                if let nextMusicFilePath = PlayFlowRepository.getNextMusicFilePath() {
                    guard PlayFlowRepository.removePlayNextM3U8(filePath: nextMusicFilePath) else { return }
                    print("removeSucceeded")
                    guard let readFolder = readFolderDataStore.readFolderList.get(fullPath: nextMusicFilePath) else { return }
                    guard let nextMusic = await MusicRepository.getMusic(filePath: nextMusicFilePath, readFolder: readFolder) else { return }
                    musicChoosed(music: nextMusic, playGroup: playDataStore.playGroup)
                } else {
                    playDataStore.seekPosition = 0.0
                    playDataStore.playingMusic = nil
                }
            }
        case .sameRepeat:
            if let music = playDataStore.playingMusic {
                musicChoosed(music: music, playGroup: playDataStore.playGroup)
            }
        }
    }
    
//    static func movePreviousMusic() {
//        stop()
//        seekPosition = 0.0
//        cashedSeekBarSeconds = 0.0
//        switch playMode {
//        case .shuffle:
//            Task {
//                guard let playingMusic = self.playingMusic else { return }
//                guard WillPlayRepository.insertWillPlay(newMusicFilePath: playingMusic.filePath, at: 0) else { return }
//                print("addSucceeded")
//                if let previousMusic = await PlayedRepository.previousMusic() {
//                    guard PlayedRepository.removePlayed(filePath: previousMusic.filePath) else { return }
//                    print("removeSucceeded")
//                    musicChoosed(music: previousMusic, playGroup: playGroup)
//                } else {
//                    seekPosition = 0.0
//                    self.playingMusic = nil
//                }
//            }
//        case .order:
//            Task {
//                guard let playingMusic = self.playingMusic else { return }
//                guard WillPlayRepository.insertWillPlay(newMusicFilePath: playingMusic.filePath, at: 0) else { return }
//                print("addSucceeded")
//                if let previousMusic = await PlayedRepository.previousMusic() {
//                    guard PlayedRepository.removePlayed(filePath: previousMusic.filePath) else { return }
//                    print("removeSucceeded")
//                    musicChoosed(music: previousMusic, playGroup: playGroup)
//                } else {
//                    seekPosition = 0.0
//                    self.playingMusic = nil
//                }
//            }
//        case .sameRepeat:
//            if let music = self.playingMusic {
//                musicChoosed(music: music, playGroup: playGroup)
//            }
//        }
//    }
    
    static func setSeek() {
        guard let bookmarkDataURL = playDataStore.playingMusic?.readFolder.bookmarkDataURL else { return }
        guard bookmarkDataURL.startAccessingSecurityScopedResource() else { return }
        defer { bookmarkDataURL.stopAccessingSecurityScopedResource() }
        guard let audioFile = try? AVAudioFile(forReading: bookmarkDataURL) else { return }
        // サンプルレートを取得する
        let sampleRate = audioFile.processingFormat.sampleRate
        // 変更する秒数のSampleTimeを取得する
        let startSampleTime = AVAudioFramePosition(sampleRate * playDataStore.seekPosition)
        // 変更した後の曲の残り時間とそのSampleTimeを取得する(曲の秒数-変更する秒数)
        let length = playDataStore.playingMusic?.musicLength ?? 300 - playDataStore.seekPosition
        let remainSampleTime = AVAudioFrameCount(length * Double(sampleRate))
        // 変更した秒数をキャッシュしておく
        playDataStore.cashedSeekBarSeconds = Double(playDataStore.seekPosition)
        // 変更した秒数から曲を再生し直すため、AudioEngineとPlayerNodeを停止する
        stop()
        // 曲の再生秒数の変更メソッド
        playDataStore.playerNode.scheduleSegment(audioFile, startingFrame: startSampleTime, frameCount: remainSampleTime, at: nil)
//        notificationRepository.setNowPlayingInfo()
        // 停止状態なので再生する
        play()
    }
    
    static func setEqualizer(equalizerParameters: [EqualizerParameter]) {
        playDataStore.equalizerNode.bypass = !playDataStore.equalizerToggle
        if equalizerParameters.isEmpty {
            let frequencys: [Float] = [32.0, 64.0, 128.0, 256.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
            playDataStore.equalizerNode.bands.enumerated().forEach { index, param in
                param.filterType = .parametric
                param.bypass = !playDataStore.equalizerToggle
                param.bandwidth = 1
                param.frequency = frequencys[index]
                param.gain = 0.0
            }
        } else {
            playDataStore.equalizerNode.bands.enumerated().forEach { index, param in
                param.filterType = .parametric
                param.bypass = !playDataStore.equalizerToggle
                param.bandwidth = equalizerParameters[index].bandWidth
                param.frequency = equalizerParameters[index].frequency
                param.gain = equalizerParameters[index].gain
            }
        }
    }
    
    static func musicChoosed(music: Music, playGroup: PlayDataStore.PlayGroup) {
        guard let filePath = music.fullPath else { return }
        if FileService.isExistFile(filePath: filePath) {
            playDataStore.playGroup = playGroup
            setMusic(music: music)
            //            UserDefaultsRepository.savePlayingMusicFilePath(filePath: music.filePath)
            setScheduleFile()
            playDataStore.seekPosition = 0.0
            playDataStore.cashedSeekBarSeconds = 0.0
            play()
            setTimer()
        } else {
//            Task {
//                switch playGroup {
//                case .music:
//                    MusicDataStore.shared.musicArray = await MusicRepository.getMusics()
//                    guard let music = MusicDataStore.shared.musicArray.randomElement() else { return }
//                    musicChoosed(music: music, playGroup: .music)
//                case .artist:
//                    guard let artistName = ArtistDataStore.shared.selectedArtist?.artistName else { return }
//                    ArtistDataStore.shared.artistMusicArray = await ArtistRepository.getArtistMusic(artistName: artistName)
//                    guard let music = ArtistDataStore.shared.artistMusicArray.randomElement() else { return }
//                    musicChoosed(music: music, playGroup: .artist)
//                case .album:
//                    guard let albumName = AlbumDataStore.shared.selectedAlbum?.albumName else { return }
//                    AlbumDataStore.shared.albumMusicArray = await AlbumRepository.getAlbumMusic(albumName: albumName)
//                    guard let music = AlbumDataStore.shared.albumMusicArray.randomElement() else { return }
//                    musicChoosed(music: music, playGroup: .album)
//                case .playlist:
//                    guard let filePath = PlaylistDataStore.shared.selectedPlaylist?.filePath else { return }
//                    PlaylistDataStore.shared.playlistMusicArray = await PlaylistRepository.getPlaylistMusic(filePath: filePath)
//                    guard let music = PlaylistDataStore.shared.playlistMusicArray.randomElement() else { return }
//                    musicChoosed(music: music, playGroup: .playlist)
//                case .folder:
//                    guard let folderPath = FolderDataStore.shared.selectedFolder?.folderPath else { return }
//                    FolderDataStore.shared.folderMusicArray = await FolderRepository.getFolderMusic(folderPath: folderPath)
//                    guard let music = FolderDataStore.shared.folderMusicArray.randomElement() else { return }
//                    musicChoosed(music: music, playGroup: .folder)
//                case .favorite:
//                    FavoriteMusicDataStore.shared.favoriteMusicArray = await FavoriteMusicRepository.getFavoriteMusics()
//                    guard let music = FavoriteMusicDataStore.shared.favoriteMusicArray.randomElement() else { return }
//                    musicChoosed(music: music, playGroup: .favorite)
//                }
//            }
        }
    }
    
//    static func moveChoosedMusic(music: Music) async {
//        if FileService.isExistFile(filePath: music.filePath) {
//            setMusic(music: music)
//            UserDefaultsRepository.savePlayingMusicFilePath(filePath: music.filePath)
//            setScheduleFile()
//            seekPosition = 0.0
//            cashedSeekBarSeconds = 0.0
//            play()
//            setTimer()
//        } else {
//            if let nextMusic = await WillPlayRepository.nextMusic() {
//                guard WillPlayRepository.removeWillPlay(filePath: nextMusic.filePath) else { return }
//                await moveChoosedMusic(music: nextMusic)
//            } else {
//                self.playingMusic = nil
//            }
//        }
//    }
    
    static func setNextMusics(fullPaths: [String]) {
        var filePaths = fullPaths
        guard let musicFilePath = playDataStore.playingMusic?.filePath else { return }
        filePaths.remove(string: musicFilePath)
        switch playDataStore.playMode {
        case .shuffle:
            filePaths.shuffle()
        case .order:
            filePaths.sort { $0 < $1 }
        case .sameRepeat:
            filePaths = []
        }
        guard PlayFlowRepository.cleanUpPlayBackM3U8() else { return }
        guard PlayFlowRepository.cleanUpPlayNextM3U8() else { return }
        guard PlayFlowRepository.writePlayNextM3U8(filePaths: filePaths) else { return }
        print("setSucceeded")
    }
    
//    static func setPlayMode(playMode: PlayMode) {
//        self.playMode = playMode
//        guard WillPlayRepository.sortWillPlay(playMode: playMode, playGroup: playGroup) else { return }
//        print("sortSucceeded")
//        UserDefaultsRepository.savePlayMode(playMode: playMode)
//    }
    
//    static func changePlayMode() {
//        switch playMode {
//        case .shuffle:
//            playMode = .order
//        case .order:
//            playMode = .sameRepeat
//        case .sameRepeat:
//            playMode = .shuffle
//        }
//        guard WillPlayRepository.sortWillPlay(playMode: playMode, playGroup: playGroup) else { return }
//        print("sortSucceeded")
//        UserDefaultsRepository.savePlayMode(playMode: playMode)
//    }
}
