//
//  StoredObjectManager.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation

class StoredObjectManager<T: Codable>: ObservableObject {
    @Published var objects: T! {
        didSet {
            storeObjects()
        }
    }
    private let defaultValue: T

    let fileManager = FilesManager()
    let filename: String

    init(filename: String, defaultValue: T) {
        self.filename = filename
        self.defaultValue = defaultValue
        self.loadObjects(defaultValue: defaultValue)
    }

    func storeObjects() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.objects)
            try fileManager.save(fileNamed: self.filename, data: data, overwrite: true)
        } catch {
            debugPrint("Unable to save effects")
        }
    }

    private func loadObjects(defaultValue: T) {
        let decoder = JSONDecoder()
        do {
            let fileData = try fileManager.read(fileNamed: filename)
            self.objects = try decoder.decode(T.self, from: fileData)
        } catch {
            self.objects = defaultValue
        }
    }
}
