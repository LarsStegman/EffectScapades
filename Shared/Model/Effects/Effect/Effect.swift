//
//  Effect.swift
//  EffectScapades
//
//  Created by Lars Stegman on 01/01/2021.
//

import Foundation

struct Effect: Identifiable {
    let id: UUID
    let name: String
    var soundEffect: EffectSoundComponent? = nil
    
    var duration: Float {
        return 0.0 // moet max van geluid en licht worden
    }

    func render<S: SoundRenderer>(soundRenderer: S) {
        self.soundEffect?.render(renderer: soundRenderer)
    }
}

protocol EffectComponent {}

protocol EffectComponentRenderer: ObservableObject {
    var progress: Double { get }
    var isPlaying: Bool { get }
    func play()
    func stop()
}

