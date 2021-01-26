//
//  SoundSourceBundleFileConfigurationFile.swift
//  EffectScapades
//
//  Created by Lars Stegman on 17/01/2021.
//

import SwiftUI

struct SoundSourceBundleFileConfigurationView: View {
    @Binding var soundSource: SoundSource?

    var body: some View {
        List {
            TextField("Filename", text: Binding(get: {
                if case .bundleFile(let name) = self.soundSource {
                    return name
                } else {
                    return ""
                }
            }, set: { filename in
                self.soundSource = .bundleFile(name: filename)
            }))
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct SoundSourceBundleFileConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSourceBundleFileConfigurationView(soundSource: .constant(.bundleFile(name: "hi")))
    }
}
