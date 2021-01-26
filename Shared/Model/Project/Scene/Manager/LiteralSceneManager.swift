//
//  LiteralSceneManager.swift
//  EffectScapades
//
//  Created by Lars Stegman on 07/01/2021.
//

import Foundation

class LiteralSceneManager: SceneManager {
    @Published var scenes: SceneFolder

    init(scenes: SceneFolder) {
        self.scenes = scenes
    }
}
