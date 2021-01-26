//
//  LiteralProjectManager.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation

class LiteralProjectManager: ProjectManager {
    @Published var projects: [UUID: Project]

    init(projects: [Project]) {
        self.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
    }
}
