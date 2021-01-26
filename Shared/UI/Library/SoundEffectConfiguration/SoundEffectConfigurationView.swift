//
//  SoundEffectConfiguationView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 16/01/2021.
//

import SwiftUI
import MediaPlayer

extension SoundSource {
    var name: String {
        switch self {
        case .bundleFile(let name):
            return name
        case .mpMediaItem(let id):
            let predicate = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            return query.items?.first?.title ?? "\(id)"
        }
    }
}

struct SoundEffectConfigurationView: View {
    @Binding var soundEffect: SoundEffect?
    @State private var soundSource: SoundSource?
    @State private var repeats: Bool

    init(soundEffect: Binding<SoundEffect?>) {
        self._soundEffect = soundEffect
        self._soundSource = .init(initialValue: soundEffect.wrappedValue?.source)
        self._repeats = .init(initialValue: soundEffect.wrappedValue?.repeats ?? false)
    }

    var body: some View {
        Group {
            NavigationLink(destination: SoundSourceConfigurationView(soundSource: $soundSource.animation())) {
                HStack {
                    Text("Source")
                    Spacer()
                    if let sourceName = soundSource?.name {
                        Text(sourceName)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                }
            }
            if soundSource != nil {
                Toggle("Repeats", isOn: $repeats)
            }
        }
        .onChange(of: soundSource) { _ in self.updateSoundEffect() }
        .onChange(of: repeats) { _ in self.updateSoundEffect() }
    }

    private func updateSoundEffect() {
        if let source = soundSource {
            self.soundEffect = SoundEffect(source: source, repeats: repeats)
        } else {
            self.soundEffect = nil
        }
    }
}

//struct SoundEffectConfigurationView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundEffectConfigurationView(soundEffect: )
//    }
//}
