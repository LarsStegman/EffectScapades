//
//  EffectScapadesApp.swift
//  Shared
//
//  Created by Lars Stegman on 01/01/2021.
//

import SwiftUI

@main
struct EffectScapadesApp: App {

    let effectPlayer: some EffectPlayerProtocol = EffectPlayer(
        soundRendererConstructor: AVAudioSoundRenderer.init,
        effects: [
            Effect(id: UUID(), name: "Ice Temple", soundEffect: SoundEffect(file: "IceTemple.mp3")),
            Effect(id: UUID(), name: "Fireball", soundEffect: SoundEffect(file: "fireball.m4a")),
        ]
    ).eraseToAnyEffectPlayer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color(UIColor.systemBackground))
                .environmentObject(effectPlayer)
        }
    }
}
