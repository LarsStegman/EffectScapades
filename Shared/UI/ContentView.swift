//
//  ContentView.swift
//  Shared
//
//  Created by Lars Stegman on 01/01/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var effectPlayer: AnyEffectPlayer

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(minimum: 150, maximum: 200)), GridItem(.flexible(minimum: 150, maximum: 200))], alignment: .center, spacing: 8) {
                ForEach(effectPlayer.effects, id: \.id) { effect in
                    let status = effectPlayer.status[effect.id]
                    EffectStatusButton(action: {
                        guard let isPlaying = status?.isPlaying else { return }
                        if isPlaying {
                            effectPlayer.stop(effect: effect.id)
                        } else {
                            effectPlayer.play(effect: effect.id)
                        }
                    },effect: effect, status: status)
                        .accentColor(.red)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 6S")
            .environmentObject(
                EffectPlayer(
                    soundRendererConstructor: DebugPrintSoundRenderer.init,
                    effects: [
                        Effect(id: UUID(), name: "Test effect 1"),
                        Effect(id: UUID(), name: "Test effect 2")
                    ]
                ).eraseToAnyEffectPlayer()
            )
    }
}
