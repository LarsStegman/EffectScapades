//
//  StoredProjectManager.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation

class StoredProjectManager: StoredObjectManager<[UUID: Project]>, ProjectManager {
    var projects: [UUID : Project] {
        get {
            objects
        }
        set {
            objects = newValue
        }
    }
}


extension StoredProjectManager {
    static let `default` = StoredProjectManager(filename: "project-lib", defaultValue: [:])
}
