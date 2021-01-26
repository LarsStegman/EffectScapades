//
//  SoundEffect.swift
//  EffectScapades
//
//  Created by Lars Stegman on 01/01/2021.
//

import Foundation


protocol SoundRenderer: EffectComponentRenderer {
    func prepare(file: URL)
}

struct SoundEffect: EffectComponent, Equatable {
    let source: SoundSource
    let repeats: Bool

    internal init(source: SoundSource, repeats: Bool = false) {
        self.source = source
        self.repeats = repeats
    }

    func render<T: SoundRenderer>(renderer: T) {
        renderer.repeats = self.repeats
        do {
            renderer.prepare(file: try source.url())
        } catch {

        }
    }
}
