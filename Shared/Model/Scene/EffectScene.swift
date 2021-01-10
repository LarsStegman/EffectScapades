//
//  EffectScene.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 05/01/2021.
//

import Foundation

struct EffectSceneSettings: Codable {
    let autoplay: Bool
}

struct EffectScene: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    
    let effects: [UUID]
    var settings: [UUID: EffectSceneSettings]
}
