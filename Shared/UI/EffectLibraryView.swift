//
//  EffectLibraryView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import SwiftUI

struct EffectLibraryView: View {
    @EnvironmentObject var effectLibrary: AnyEffectLibrary

    var columns = [
        GridItem(.adaptive(minimum: 100, maximum: 150))
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center) {
            ForEach(Array(effectLibrary.effects.values)) { effect in
                EffectStatusView(effect: effect)
            }
        }
    }
}

struct EffectLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        EffectLibraryView()
    }
}
