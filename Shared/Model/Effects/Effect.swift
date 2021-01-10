//
//  Effect.swift
//  EffectScapades
//
//  Created by Lars Stegman on 01/01/2021.
//

import Foundation
import SwiftUI

struct EffectSettings: Codable {
    let accentColor: Color?
}

extension EffectSettings {
    static let `default` = EffectSettings(accentColor: nil)
}

struct Effect: Identifiable, Codable {
    let id: UUID
    let name: String
    let settings: EffectSettings

    var soundEffect: SoundEffect? = nil

    func render<S: SoundRenderer>(soundRenderer: S) {
        self.soundEffect?.render(renderer: soundRenderer)
    }
}

extension Effect {
    var repeats: Bool {
        return self.soundEffect?.repeats ?? false
    }
}

protocol EffectComponent: Codable {
    var repeats: Bool { get }
}

protocol EffectComponentRenderer: ObservableObject {
    var progress: Double { get }
    var isPlaying: Bool { get }
    var repeats: Bool { get set }
    func play()
    func stop()
}

