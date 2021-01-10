//
//  SceneManager.swift
//  EffectScapades
//
//  Created by Lars Stegman on 07/01/2021.
//

import Foundation

typealias SceneNode = Tree<SceneDescription, EffectScene>

protocol SceneManager: ObservableObject {
    var scenes: SceneNode? { get set }
    var activeScene: EffectScene? { get set }

    func play(scene: UUID)
}

extension SceneManager {
    private var queue: [EffectScene] { return scenes?.inorder() ?? [] }
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
        self.activeScene = self.scenes?.find(scene)
    }
}

class AnySceneManager: SceneManager {
    private var _scenesGetter: () -> SceneNode?
    private var _scenesSetter: (SceneNode?) -> Void
    private var _activeSceneGetter: () -> EffectScene?
    private var _activeSceneSetter: (EffectScene?) -> Void
    private var _play: (UUID) -> Void

    var scenes: SceneNode? {
        get {
            return _scenesGetter()
        }
        set {
            _scenesSetter(newValue)
        }
    }

    var activeScene: EffectScene? {
        get {
            return _activeSceneGetter()
        }
        set {
            return _activeSceneSetter(newValue)
        }
    }

    init<S: SceneManager>(_ sceneManager: S) {
        self._scenesGetter = { sceneManager.scenes }
        self._scenesSetter = { sceneManager.scenes = $0 }
        self._activeSceneGetter = { sceneManager.activeScene }
        self._activeSceneSetter = { sceneManager.activeScene = $0}
        self._play = sceneManager.play
    }

    func play(scene: UUID) {
        _play(scene)
    }
}

extension SceneManager {
    func eraseToAnySceneManager() -> AnySceneManager {
        return AnySceneManager(self)
    }
}

