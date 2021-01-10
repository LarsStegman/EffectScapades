//
//  LiteralLibrary.swift
//  EffectScapades
//
//  Created by Lars Stegman on 05/01/2021.
//

import Foundation

class LiteralLibrary: EffectLibrary {
    @Published var effects: [UUID: Effect]

    init(effects: [Effect]) {
        self.effects = Dictionary(uniqueKeysWithValues: effects.map { ($0.id, $0) })
    }
}
