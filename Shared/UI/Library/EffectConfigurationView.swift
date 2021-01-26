//
//  EffectConfigurationView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 15/01/2021.
//

import SwiftUI

struct EffectConfigurationView: View {
    @EnvironmentObject var effectLibrary: AnyEffectLibrary

    @State private var savedEffect: Effect?
    private var didChange: Bool {
        return savedEffect?.name != name ||
            savedEffect?.settings.accentColor != accentColor ||
            savedEffect?.soundEffect != soundEffect
    }

    @State var name: String = ""
    @State var accentColor: Color = .random
    @State var soundEffectEnabled: Bool = false
    @State var soundEffect: SoundEffect?

    @Environment(\.presentationMode) var presentation

    var createEffect: Bool {
        return savedEffect == nil
    }

    init(effect: Effect? = nil) {
        self._savedEffect = .init(initialValue: effect)
        self._name = .init(initialValue: effect?.name ?? "")
        self._accentColor = .init(initialValue: effect?.settings.accentColor ?? .random)
        self._soundEffectEnabled = .init(initialValue: effect?.soundEffect != nil)
        self._soundEffect = .init(initialValue: effect?.soundEffect)
    }

    private func load(effect: Effect?) {
        self.name = effect?.name ?? ""
        self.accentColor = effect?.settings.accentColor ?? .random
        self.soundEffect = effect?.soundEffect
        self.soundEffectEnabled = effect?.soundEffect != nil
        self.savedEffect = effect
    }

    var leading: some View {
        Group {
            if createEffect || didChange {
                Button("Cancel", action: {
                    if createEffect {
                        self.presentation.wrappedValue.dismiss()
                    } else if didChange {
                        self.load(effect: savedEffect)
                    }
                })
            } else {
                EmptyView()
            }
        }
    }

    var trailing: some View {
        Group {
            if createEffect {
                Button("Create", action: {
                    self.saveEffect()
                })
                .disabled(name.count < 1)
            } else if didChange {
                Button("Save", action: {
                    self.saveEffect()
                })
                .disabled(name.count < 1)
            } else {
                EmptyView()
            }
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                ColorPicker("Accent color", selection: $accentColor, supportsOpacity: false)
            }

            Section {
                Toggle("Sound", isOn: $soundEffectEnabled.animation())
                if soundEffectEnabled {
                    SoundEffectConfigurationView(soundEffect: $soundEffect)
                }
            }
        }
        .navigationBarTitle(name, displayMode: .inline)
        .navigationBarBackButtonHidden(createEffect || didChange)
        .navigationBarItems(leading: leading, trailing: trailing)
    }

    private func saveEffect() {
        guard name.count > 0 else {
            return
        }

        let soundEffect: SoundEffect?
        if self.soundEffectEnabled {
            soundEffect = self.soundEffect
        } else {
            soundEffect = nil
        }

        let effect = Effect(id: self.savedEffect?.id ?? UUID(),
                            name: self.name,
                            settings: EffectSettings(accentColor: self.accentColor),
                            soundEffect: soundEffect)
        self.load(effect: effect)
        self.effectLibrary.effects[effect.id] = effect
    }
}

struct EffectConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        EffectConfigurationView(effect: .init(id: UUID(), name: "Fireball", settings: .init(accentColor: .red)))
    }
}
