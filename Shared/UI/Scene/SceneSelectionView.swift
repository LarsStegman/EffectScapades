//
//  SceneSelection.swift
//  EffectScapades
//
//  Created by Lars Stegman on 08/01/2021.
//

import Foundation
import SwiftUI


struct SceneSelectionView: View {
    @EnvironmentObject var sceneManager: AnySceneManager
    @State var showCreateSheet: Bool = false

    var body: some View {
        VStack {
            if !sceneManager.scenes.isEmpty {
                sceneStructureView
            } else {
                Text("No scenes")
                    .font(.system(size: 32))
            }
            Spacer()
            Divider()
            HStack {
                Spacer()
                NavigationLink(destination: CreateSceneNodeForm()) {
                    Image(systemName: "plus")
                }
                .isDetailLink(false)
            }
            .padding()
        }
    }

    var sceneStructureView: some View {
        List {
            TreeViewContent(sceneManager.scenes, defaultExpanded: true) { description in
                Text(description.name)
            } leafView: { scene in
                NavigationLink(destination: SceneView(scene: scene)) {
                    Text(scene.name)
                }
            }
//            .onDelete(perform: { index in
//                sceneManager.delete(at: index)
//            })
        }
    }
}

struct SceneSelection_Previews: PreviewProvider {
    static var previews: some View {
        let sceneStructure = [
            SceneNode.leaf(EffectScene(id: UUID(),
                                       name: "Arveiaturace",
                                       description: "Encounter with the ancient white wyrm",
                                       effects: [],
                                       settings: [:])),
            .node(description: SceneFolderDescription(id: UUID(),
                                                      name: "The Black Cabin"),
                  children: [
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

        return SceneSelectionView()
            .environmentObject(LiteralSceneManager(scenes: sceneStructure).eraseToAnySceneManager())
    }
}
