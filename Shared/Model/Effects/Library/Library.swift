//
//  Library.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import Foundation
import Combine

protocol EffectLibrary: ObservableObject {
    var effects: [UUID: Effect] { get set }
}

class AnyEffectLibrary: EffectLibrary {
    private let _effectsGet: () -> [UUID: Effect]
    private let _effectsSet: ([UUID: Effect]) -> Void
    private let _objectWillChange: ObservableObjectPublisher
    var objectWillChange: ObservableObjectPublisher {
        return _objectWillChange
    }

    var effects: [UUID: Effect] {
        get {
            self._effectsGet()
        }
        set {
            self._effectsSet(newValue)
        }
    }

    init<E: EffectLibrary>(_ lib: E) where E.ObjectWillChangePublisher: ObservableObjectPublisher {
        self._effectsGet = { lib.effects }
        self._effectsSet = { e in lib.effects = e }
        self._objectWillChange = lib.objectWillChange
    }
}

extension EffectLibrary {
    func eraseToAnyEffectLibrary() -> AnyEffectLibrary where Self.ObjectWillChangePublisher: ObservableObjectPublisher {
        return AnyEffectLibrary(self)
    }
}
