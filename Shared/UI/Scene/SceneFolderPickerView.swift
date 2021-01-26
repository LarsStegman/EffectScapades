//
//  SceneFolderSelectionView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 25/01/2021.
//

import SwiftUI

typealias SceneFolderStructure = Tree<SceneFolderDescription, SceneFolderDescription>
extension SceneNode {
    func folderStructure() -> SceneFolderStructure? {
        switch self {
        case .node(description: let d, children: let children):
            let transformedChildren = children.folderStructure()
            if transformedChildren.isEmpty {
                return .leaf(d)
            } else {
                return .node(description: d, children: transformedChildren)
            }
        case .leaf(_):
            return nil
        }
    }
}

extension SceneFolder {
    func folderStructure() -> [SceneFolderStructure] {
        self.compactMap({ sceneNode in sceneNode.folderStructure() })
    }
}

struct SceneFolderSelectionView: View {
    @EnvironmentObject var sceneManager: AnySceneManager
    @Environment(\.presentationMode) var presentationMode
    @Binding var folder: SceneFolderDescription?

    let rootId = UUID()

    var folderRoot: SceneFolderStructure {
        .node(description: SceneFolderDescription(id: rootId, name: "Root"),
              children: sceneManager.scenes.folderStructure())
    }

    var body: some View {
        TreeView(folderRoot, defaultExpanded: true) { folder in
            sceneFolder(folder: folder)
        } leafView: { folder in
            sceneFolder(folder: folder)
        }
    }

    func sceneFolder(folder: SceneFolderDescription) -> some View {
        Button(action: {
            self.select(folder: folder)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "folder")
                Text(folder.name)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func select(folder: SceneFolderDescription) {
        if folder.id == rootId {
            self.folder = nil
        } else {
            self.folder = folder
        }
    }
}


struct SceneFolderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let folder = SceneFolderDescription(id: UUID(),
                                            name: "The Black Cabin")
        let sceneStructure = [
            SceneNode.leaf(EffectScene(id: UUID(),
                                       name: "Arveiaturace",
                                       description: "Encounter with the ancient white wyrm",
                                       effects: [],
                                       settings: [:])),
            .node(description: folder, children: [
                .leaf(EffectScene(id: UUID(),
                                  name: "Entering the cabin",
                                  description: "Watch out for the floor",
                                  effects: [],
                                  settings: [:])),
                .leaf(EffectScene(id: UUID(),
                                  name: "Activating the sphere",
                                  description: "Better make that save",
                                  effects: [],
                                  settings: [:]))
            ])
        ]

        return SceneFolderSelectionView(folder: .constant(folder))
            .environmentObject(LiteralSceneManager(scenes: sceneStructure).eraseToAnySceneManager())
    }
}
