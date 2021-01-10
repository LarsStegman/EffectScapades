//
//  LiteralSceneManager.swift
//  EffectScapades
//
//  Created by Lars Stegman on 07/01/2021.
//

import Foundation

class LiteralSceneManager: SceneManager {
    @Published var scenes: SceneNode?
    @Published var activeScene: EffectScene? = nil

    init(scenes: SceneNode? = nil) {
        self.scenes = scenes
    }
}
