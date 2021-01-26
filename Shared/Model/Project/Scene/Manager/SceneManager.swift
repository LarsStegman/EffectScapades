//
//  SceneManager.swift
//  EffectScapades
//
//  Created by Lars Stegman on 07/01/2021.
//

import Foundation
import Combine

protocol SceneManager: ObservableObject {
    var scenes: SceneFolder { get set }
}


class AnySceneManager: SceneManager {
    private var _scenesGetter: () -> SceneFolder
    private var _scenesSetter: (SceneFolder) -> Void

    private var _objectWillChange: ObservableObjectPublisher
    var objectWillChange: ObservableObjectPublisher {
        return _objectWillChange
    }

    var scenes: SceneFolder {
        get {
            return _scenesGetter()
        }
        set {
            _scenesSetter(newValue)
        }
    }

    init<S: SceneManager>(_ sceneManager: S) where S.ObjectWillChangePublisher: ObservableObjectPublisher {
        self._scenesGetter = { sceneManager.scenes }
        self._scenesSetter = { sceneManager.scenes = $0 }
        self._objectWillChange = sceneManager.objectWillChange
    }
}

extension SceneManager {
    func eraseToAnySceneManager() -> AnySceneManager where Self.ObjectWillChangePublisher: ObservableObjectPublisher {
        return AnySceneManager(self)
    }
}

