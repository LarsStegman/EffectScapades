//
//  DebugSoundRenderer.swift
//  EffectScapades
//
//  Created by Lars Stegman on 02/01/2021.
//

import Foundation
import Combine

class DebugPrintSoundRenderer: SoundRenderer {
    func prepare(file: String) {
        print("Loading file \(file)")
    }

    private var progressCounter = 0 {
        willSet {
            self.objectWillChange.send()
        }
    }
    private var progressSimulation: AnyCancellable? = nil
    private let intervals = 10
    var progress: Double {
        return Double(progressCounter) / Double(intervals)
    }

    @Published var isPlaying: Bool = false

    func play() {
        print("Playing...")
        self.isPlaying = true
        progressSimulation = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let s = self else { return }
                self?.progressCounter += 1
                if s.progressCounter > s.intervals {
                    self?.progressSimulation?.cancel()
                    self?.stop()
                }
            }
    }

    func stop() {
        print("Stop playing...")
        self.progressCounter = 0
        self.isPlaying = false
        progressSimulation = nil
    }
}
