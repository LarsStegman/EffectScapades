//
//  ContentView.swift
//  Shared
//
//  Created by Lars Stegman on 01/01/2021.
//

import SwiftUI

struct SceneView: View {
    @EnvironmentObject var effectPlayer: AnyEffectPlayer
    @EnvironmentObject var library: AnyEffectLibrary

    var scene: EffectScene

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 120, maximum: 150))]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center) {
                Section(header: HStack {
                    Text("Effects")
                        .font(.title)
                    Spacer()
                }) {
                    ForEach(scene.effects, id: \.self) { effectId in
                        Group {
                            if let effect = library.effects[effectId] {
                                Button(action: { effectPlayer.toggle(effectId) }) {
                                    EffectStatusView(
                                        effect: effect,
                                        status: effectPlayer.status(of: effectId)
                                    ).accentColor(effect.settings.accentColor)
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(scene.name)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let lib = LiteralLibrary(effects: [
           Effect(id: UUID(), name: "Test effect 1", settings: .default),
           Effect(id: UUID(), name: "Test effect 2", settings: .default)
        ])
        let scene = EffectScene(id: UUID(),
                          name: "Test scene",
                          description: "A scene used for testing",
                          effects: lib.effects.values.map({ e in e.id }),
                          settings: [:])
        SceneView(scene: scene)
            .previewDevice("iPhone 6S")
            .environmentObject(
                EffectPlayer(
                    soundRendererConstructor: DebugPrintSoundRenderer.init,
                    effectLibrary: lib.eraseToAnyEffectLibrary()
                ).eraseToAnyEffectPlayer()
            )
    }
}
