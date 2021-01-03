//
//  SoundRenderer.swift
//  EffectScapades
//
//  Created by Lars Stegman on 01/01/2021.
//

import Foundation
import AVKit
import Combine

class AVAudioSoundRenderer: SoundRenderer {
    class AVAudioPlayerObserver: NSObject, AVAudioPlayerDelegate {
        @Published var isPlaying: Bool = false
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            self.isPlaying = false
        }
    }
    private var playerObservers = Set<AnyCancellable>()
    
    @Published var progress: Double = 0.5
    @Published var isPlaying: Bool = false

    private lazy var avAudioPlayerObserver: AVAudioPlayerObserver = {
        let observer = AVAudioPlayerObserver()
        observer.$isPlaying.assign(to: &$isPlaying)
        return observer
    }()
    private var avAudioPlayer: AVAudioPlayer? {
        didSet {
            self.playerObservers.removeAll(keepingCapacity: true)
            self.avAudioPlayer?.delegate = avAudioPlayerObserver
            Timer.publish(every: 1/60, on: .main, in: .default)
                .autoconnect()
                .sink { [weak self] _ in
                    if let player = self?.avAudioPlayer {
                        self?.progress = player.currentTime / player.duration
                    } else {
                        self?.progress = 0
                    }
                }
                .store(in: &playerObservers)
        }
    }

    func prepare(file: String) {
        print("AVAudioSoundRenderer: play(file: \(file))")
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            print("AVAudioSoundRenderer: url not found")
            return
        }

        do {
            self.avAudioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("AVAudioSoundRenderer: loading content not possible")
        }
    }

    func play() {
        self.avAudioPlayer?.play()
        isPlaying = self.avAudioPlayer?.isPlaying ?? false
    }

    func stop() {
        self.avAudioPlayer?.stop()
        self.isPlaying = self.avAudioPlayer?.isPlaying ?? false
        self.progress = 0
    }
}
