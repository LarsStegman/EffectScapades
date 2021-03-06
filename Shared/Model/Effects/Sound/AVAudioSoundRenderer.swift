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
    private lazy var displayLink: CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(updateProgress))
    }()

    @Published var progress: Double = 0.0
    @Published var isPlaying: Bool = false {
        didSet {
            self.createDisplayLink()
        }
    }
    var repeats: Bool = false

    private lazy var avAudioPlayerObserver: AVAudioPlayerObserver = {
        let observer = AVAudioPlayerObserver()
        observer.$isPlaying.sink { self.isPlayingUpdates(isPlaying: $0) }.store(in: &playerObservers)
        return observer
    }()
    private var avAudioPlayer: AVAudioPlayer? {
        didSet {
            self.playerObservers.forEach { c in c.cancel() }

            self.playerObservers.removeAll(keepingCapacity: true)
            self.avAudioPlayer?.numberOfLoops = 0
            self.avAudioPlayer?.delegate = avAudioPlayerObserver
        }
    }

    private func isPlayingUpdates(isPlaying: Bool) {
        if self.repeats && !isPlaying {
            self.play()
        } else {
            self.isPlaying = isPlaying
        }
    }

    @objc private func updateProgress() {
        if let player = self.avAudioPlayer {
            self.progress = player.currentTime / player.duration
        } else {
            self.progress = 0
        }
    }

    private func createDisplayLink() {
        if isPlaying {
            self.displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
            self.displayLink.add(to: .current, forMode: .common)
        } else {
            self.displayLink.invalidate()
        }
    }

    func prepare(file: URL) {
        do {
            self.avAudioPlayer = try AVAudioPlayer(contentsOf: file)
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
