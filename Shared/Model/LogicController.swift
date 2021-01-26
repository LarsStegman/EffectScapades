//
//  LogicController.swift
//  EffectScapades
//
//  Created by Lars Stegman on 05/01/2021.
//

import Foundation

class LogicController {
    let library: AnyEffectLibrary
    let sceneManager: AnySceneManager

    private(set) lazy var effectPlayer: EffectPlayer = {
        EffectPlayer(
            soundRendererConstructor: AVAudioSoundRenderer.init,
            effectLibrary: self.library)
    }()

    init(library: AnyEffectLibrary,
         sceneManager: AnySceneManager = LiteralSceneManager(scenes: [
            .leaf(EffectScene(id: UUID(),
                             name: "Black Cabin",
                             description: "A cabin on the edge of a precipice",
                             effects: [],
                             settings: [:]))
         ]).eraseToAnySceneManager()) {
        self.library = library
        self.sceneManager = sceneManager
    }
}
