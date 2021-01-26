//
//  EffectScapadesApp.swift
//  Shared
//
//  Created by Lars Stegman on 01/01/2021.
//

import SwiftUI

@main
struct EffectScapadesApp: App {

    let library: AnyEffectLibrary = LiteralLibrary(effects: [
        Effect(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, name: "Ice Temple",
               settings: EffectSettings(accentColor: .purple),
               soundEffect: SoundEffect(source: .bundleFile(name: "IceTemple.mp3"), repeats: true)),
        Effect(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!, name: "Fireball",
               settings: EffectSettings(accentColor: .red),
               soundEffect: SoundEffect(source: .bundleFile(name: "fireball.m4a"))),
    ]).eraseToAnyEffectLibrary()
    let projectsManager: AnyProjectManager = LiteralProjectManager(projects: [
        .exampleProject(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440018")!)
    ]).eraseToAnyProjectManager()

    @State private var showEffectLibrary: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                NavigationView {
                    VStack {
                        ProjectOverviewView()
                        Divider()
                        Button(action: { self.showEffectLibrary.toggle() }) {
                            Text("Effects Library")
                        }
                        .padding()
                    }
                    .navigationTitle("Projects")
                }
                .fullScreenCover(isPresented: $showEffectLibrary) {
                    EffectLibraryView()
                }
            }
            .environmentObject(library)
            .environmentObject(projectsManager)
        }
    }
}
