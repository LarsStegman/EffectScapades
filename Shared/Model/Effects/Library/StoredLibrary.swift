//
//  StoredLibrary.swift
//  EffectScapades
//
//  Created by Lars Stegman on 05/01/2021.
//

import Foundation

class StoredEffectLibrary: EffectLibrary {
    @Published var effects: [UUID: Effect] {
        didSet {
            storeEffects()
        }
    }

    let fileManager = FilesManager()
    let filename: String

    init(filename: String = "effect-lib") {
        self.filename = filename
        if let fileData = try? fileManager.read(fileNamed: filename) {
            let decoder = JSONDecoder()
            self.effects = (try? decoder.decode([UUID: Effect].self, from: fileData)) ?? [:]
        } else {
            self.effects = [:]
        }
    }

    func storeEffects() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.effects)
            try fileManager.save(fileNamed: self.filename, data: data, overwrite: true)
        } catch {
            debugPrint("Unable to save effects")
        }

    }
}

extension StoredEffectLibrary {
    static let `default` = StoredEffectLibrary()
}
