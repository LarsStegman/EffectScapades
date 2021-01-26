//
//  StoredSceneManager.swift
//  EffectScapades
//
//  Created by Lars Stegman on 15/01/2021.
//

import Foundation
import Combine


class StoredSceneManager: StoredObjectManager<SceneFolder>, SceneManager {
    var scenes: SceneFolder {
        get {
            return self.objects
        }
        set {
            self.objects = newValue
        }
    }

    init(project: Project) {
        super.init(filename: "scene-lib-\(project.id)",
                   defaultValue: [])
    }
}
