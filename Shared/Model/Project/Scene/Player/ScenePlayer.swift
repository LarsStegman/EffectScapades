//
//  ScenePlayer.swift
//  EffectScapades
//
//  Created by Lars Stegman on 24/01/2021.
//

import Foundation

protocol ScenePlayer: ObservableObject {
    var scenes: SceneNode { get set }
    var activeScene: EffectScene? { get set }

    func play(scene: UUID)
}

extension ScenePlayer {
    private var queue: [EffectScene] { return scenes.inorder() }
    private var activeIndex: Array<EffectScene>.Index? {
        guard let active = activeScene?.id else { return nil }
        return queue.firstIndex(where: { $0.id == active })
    }

    var previous: EffectScene? {
        guard let idx = activeIndex else { return nil }
        return queue[idx.advanced(by: -1)]
    }

    var next: EffectScene? {
        guard let idx = activeIndex else { return nil }
        return queue[idx.advanced(by: 1)]
    }

    func playNext() {
        self.activeScene = next
    }

    func playPrevious() {
       self.activeScene = previous
    }

    func play(scene: UUID) {
        self.activeScene = self.scenes.find(scene)
    }
}
