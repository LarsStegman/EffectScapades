//
//  EffectLibraryView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import SwiftUI

struct EffectLibraryView: View {
    @EnvironmentObject var effectLibrary: AnyEffectLibrary

    private var columns = [
        GridItem(.adaptive(minimum: 100, maximum: 150))
    ]

    @Environment(\.presentationMode) var presentation

    private var leadingButtons: some View {
        Button("Close", action: {
            presentation.wrappedValue.dismiss()
        })
    }

    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: columns, alignment: .leading) {
                    ForEach(Array(effectLibrary.effects.values)) { effect in
                        NavigationLink(destination: EffectConfigurationView(effect: effect)) {
                            EffectStatusView(effect: effect)
                        }
                    }
                    NavigationLink(destination: EffectConfigurationView()) {
                        Image(systemName: "plus")
                            .font(.system(size: 32))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(32)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Effects")
            .navigationBarItems(leading: leadingButtons)
        }
    }
}

struct EffectLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        EffectLibraryView()
            .environmentObject(LiteralLibrary(effects: [
                Effect(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, name: "Ice Temple",
                       settings: EffectSettings(accentColor: .purple),
                       soundEffect: SoundEffect(source: .bundleFile(name: "IceTemple.mp3"), repeats: true)),
                Effect(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!, name: "Fireball",
                       settings: EffectSettings(accentColor: .red),
                       soundEffect: SoundEffect(source: .bundleFile(name: "fireball.m4a"))),
            ]).eraseToAnyEffectLibrary())
    }
}
