//
//  SoundEffectConfigurationView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 16/01/2021.
//

import SwiftUI

struct SoundSourceConfigurationView: View {
    @Binding var soundSource: SoundSource?

    var body: some View {
        List {
            NavigationLink(destination: SoundSourceBundleFileConfigurationView(soundSource: $soundSource)) {
                Text("Bundle file")
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

