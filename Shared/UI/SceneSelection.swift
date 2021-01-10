//
//  SceneSelection.swift
//  EffectScapades
//
//  Created by Lars Stegman on 08/01/2021.
//

import Foundation
import SwiftUI


struct SceneSelection: View {
    @EnvironmentObject var sceneManager: AnySceneManager

    var body: some View {
        if let sceneNode = sceneManager.scenes {
            TreeView(sceneNode) { description in
                Text(description.name)
            } leafView: { scene in
                NavigationLink(
                    destination: SceneView(scene: scene)) {
                    Text(scene.name)
                }
            }
            .navigationBarTitle("Scenes")
        } else {
            EmptyView()
        }
    }
}

struct SceneSelection_Previews: PreviewProvider {
    static var previews: some View {
        let sceneStructure = SceneNode.node(
            description: SceneDescription(id: UUID(), name: "grouping", description: ""),
            children: [
                .leaf(EffectScene(id: UUID(),
                                  name: "Arveiaturace",
                                  description: "Encounter with the ancient white wyrm",
                                  effects: [],
                                  settings: [:])),
                .node(description: SceneDescription(id: UUID(),
                                  name: "The Black Cabin",
                                  description: "Searching for the lost scientist"), children: [
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
            ])

        return SceneSelection()
            .environmentObject(LiteralSceneManager(scenes: sceneStructure).eraseToAnySceneManager())
    }
}
