//
//  SoundEffect.swift
//  EffectScapades
//
//  Created by Lars Stegman on 01/01/2021.
//

import Foundation


protocol SoundRenderer: EffectComponentRenderer {
    func prepare(file: String)
}

protocol EffectSoundComponent: EffectComponent {
    func render<T: SoundRenderer>(renderer: T)
}


struct SoundEffect: EffectSoundComponent {
    let file: String

    internal init(file: String) {
        self.file = file
    }

    func render<T: SoundRenderer>(renderer: T) {
        renderer.prepare(file: file)
    }
}
