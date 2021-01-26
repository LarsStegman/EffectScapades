//
//  SceneNode.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 05/01/2021.
//

import Foundation

struct SceneFolderDescription: Identifiable, Codable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}


typealias SceneNode = Tree<SceneFolderDescription, EffectScene>
typealias SceneFolder = [SceneNode]

extension SceneFolder {
    mutating func insert(_ sceneNode: SceneNode, in parent: SceneFolderDescription?) {
        if let id = parent?.id {
            self = self.map { sn in
                var sn = sn
                sn.insert(sceneNode, at: id)
                return sn
            }
        } else {
            self.append(sceneNode)
        }
    }

    mutating func insert(_ scene: EffectScene, in parent: SceneFolderDescription?) {
        self.insert(.leaf(scene), in: parent)
    }

    mutating func insert(_ folder: SceneFolderDescription, in parent: SceneFolderDescription?) {
        self.insert(.node(description: folder, children: []), in: parent)
    }
}
