//
//  EffectScapadesApp.swift
//  Shared
//
//  Created by Lars Stegman on 01/01/2021.
//

import SwiftUI

@main
struct EffectScapadesApp: App {

    let logic = LogicController(
        library: LiteralLibrary(effects: [
            Effect(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, name: "Ice Temple",
                   settings: EffectSettings(accentColor: .purple),
                   soundEffect: SoundEffect(source: .bundleFile(name: "IceTemple.mp3"), repeats: true)),
            Effect(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!, name: "Fireball",
                   settings: EffectSettings(accentColor: .red),
                   soundEffect: SoundEffect(source: .bundleFile(name: "fireball.m4a"))),
        ]).eraseToAnyEffectLibrary(),
        sceneManager: LiteralSceneManager(scenes: SceneNode.node(
                                            description: SceneDescription(id: UUID(), name: "grouping", description: ""),
                                            children: [
                                                .leaf(EffectScene(id: UUID(),
                                                                  name: "Arveiaturace",
                                                                  description: "Encounter with the ancient white wyrm",
                                                                  effects: [UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!],
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
                                            ])).eraseToAnySceneManager()
    )


    var body: some Scene {
        WindowGroup {
            NavigationView {
                SceneSelection()
                if let firstScene = logic.sceneManager.scenes?.inorder().first {
                    SceneView(scene: firstScene)
                }
            }
            .environmentObject(logic.effectPlayer.eraseToAnyEffectPlayer())
            .environmentObject(logic.library)
            .environmentObject(logic.sceneManager)
        }
    }
}
