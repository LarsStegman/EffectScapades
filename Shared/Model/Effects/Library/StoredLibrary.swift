//
//  StoredLibrary.swift
//  EffectScapades
//
//  Created by Lars Stegman on 05/01/2021.
//

import Foundation

class StoredEffectLibrary: StoredObjectManager<[UUID: Effect]>, EffectLibrary {
    var effects: [UUID: Effect] {
        get {
            objects
        }
        set {
            objects = newValue
        }
    }
}

extension StoredEffectLibrary {
    static let `default` = StoredEffectLibrary(filename: "effect-lib", defaultValue: [:])
}
