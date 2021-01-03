//
//  EffectButton.swift
//  EffectScapades
//
//  Created by Lars Stegman on 02/01/2021.
//

import Foundation
import SwiftUI

struct EffectStatusButton: View {
    @EnvironmentObject var effectPlayer: AnyEffectPlayer

    var action: () -> Void = {}
    var effect: Effect
    var status: EffectStatus?
    let progressScale: CGFloat = 0.75

    private var isPlaying: Bool {
        status?.isPlaying ?? false
    }

    var bgColor: some View {
        return isPlaying ? Color.accentColor : Color(UIColor.secondarySystemBackground)
    }

    var body: some View {
        GeometryReader { geo in
            Button(action: action) {
                ZStack(alignment: .center) {
                    Text("\(effect.name)")
                        .font(.headline)
                        .foregroundColor(isPlaying ? Color.white.opacity(0.8) : Color.accentColor)
                        .frame(maxHeight: .infinity)

                    if isPlaying {
                        ProgressView(value: status?.progress ?? 0)
                            .progressViewStyle(RadialProgressViewStyle())
                            .foregroundColor(Color.white.opacity(0.8))
                            .frame(width: geo.size.width * progressScale, height: geo.size.height * progressScale, alignment: .center)
                    }

                    VStack {
                        Spacer()
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: "bolt.fill")
                            Spacer()
                            Image(systemName: "repeat")
                        }
                        .font(.system(size: 16))
                        .foregroundColor((isPlaying ? Color.white : Color(UIColor.secondaryLabel)).opacity(0.8))
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.0, contentMode: .fit)
        .background(bgColor)
        .cornerRadius(32)
    }
}

struct EffectStatusButton_Previews: PreviewProvider {
    static let id = UUID()
    static var previews: some View {
        Group {
            EffectStatusButton(effect: Effect(id: id, name: "Test effect"),
                               status: EffectStatus(id: id, isPlaying: true, progress: 0.8))
            EffectStatusButton(effect: Effect(id: id, name: "Test effect"),
                               status: EffectStatus(id: id, isPlaying: false, progress: 0.8))
        }
        .previewLayout(.fixed(width: 200, height: 200))
        .accentColor(.pink)
    }
}

