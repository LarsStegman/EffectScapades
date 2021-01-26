//
//  Project.swift
//  EffectScapades
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation

struct Project: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let image: URL
}


extension Project {
    static func exampleProject(id: UUID = UUID()) -> Project {
        Project(id: id,
                name: "Rime of the Frostmaiden",
                description: "Auril has taken over Icewind Dale",
                image: URL(string: "https://cdn.vox-cdn.com/thumbor/otnsnkaaxM4CcK57Dd52d32Ydv8=/0x0:2040x1360/1200x800/filters:focal(1139x142:1465x468)/cdn.vox-cdn.com/uploads/chorus_image/image/66954236/Icewind_Dale_8_cropped.0.jpg")!)
    }
}
