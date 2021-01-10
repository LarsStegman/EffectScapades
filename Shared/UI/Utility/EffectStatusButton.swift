//
//  EffectButton.swift
//  EffectScapades
//
//  Created by Lars Stegman on 02/01/2021.
//

import Foundation
import SwiftUI

struct EffectStatusView: View {
    var effect: Effect
    var status: EffectStatus?
    let progressScale: CGFloat = 0.75

    private var isPlaying: Bool {
        status?.isPlaying ?? false
    }

    var accentColor: Color {
        effect.settings.accentColor ?? Color.accentColor
    }

    var background: some View {
        Group {
            if isPlaying {
                LinearGradient(
                    gradient: Gradient(colors: [accentColor.lighter(by: 0.15), accentColor]),
                    startPoint: .init(x: 0.9, y: 0.1),
                    endPoint: .init(x:0.7, y: 0.6))
            } else {
                Color(UIColor.secondarySystemBackground)
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Text("\(effect.name)")
                    .font(.headline)
                    .foregroundColor(isPlaying ? Color.white.opacity(0.8) : accentColor)
                    .frame(maxHeight: .infinity)

                if isPlaying {
                    ProgressView(value: status?.progress ?? 0)
                        .progressViewStyle(RadialProgressViewStyle())
                        .foregroundColor(Color.white.opacity(0.8))
                        .frame(width: geo.size.width * progressScale, height: geo.size.height * progressScale, alignment: .center)
                }

                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        if effect.repeats {
                            Image(systemName: "repeat")
                        }
                    }
                    Spacer()
                    HStack(alignment: .center) {
                        if effect.soundEffect != nil {
                            Image(systemName: "speaker.3.fill")
                        }
                        Image(systemName: "bolt.fill")
                        Spacer()
                    }
                }
                .font(.system(size: 12))
                .foregroundColor((isPlaying ? Color.white : Color(UIColor.secondaryLabel)).opacity(0.8))
                .padding()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.0, contentMode: .fit)
        .background(background)
        .cornerRadius(32)
    }
}

struct EffectStatusView_Previews: PreviewProvider {
    static let id = UUID()
    static var previews: some View {
        Group {
            EffectStatusView(effect: Effect(id: id, name: "Test effect", settings: EffectSettings(accentColor: .pink)),
                               status: EffectStatus(id: id, isPlaying: true, progress: 0.8))
            EffectStatusView(effect: Effect(id: id, name: "Test effect", settings: EffectSettings(accentColor: .pink)),
                               status: EffectStatus(id: id, isPlaying: false, progress: 0.8))
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}

