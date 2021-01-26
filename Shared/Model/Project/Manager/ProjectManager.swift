//
//  ProjectManager.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation

protocol ProjectManager: ObservableObject {
    var projects: [UUID: Project] { get set }
}

class AnyProjectManager: ProjectManager {
    private let _projectsGetter: () -> [UUID: Project]
    private let _projectsSetter: ([UUID: Project]) -> Void
    var projects: [UUID: Project] {
        get {
            _projectsGetter()
        }
        set {
            _projectsSetter(newValue)
        }
    }

    init<PM: ProjectManager>(_ projectManager: PM) {
        self._projectsGetter = { projectManager.projects }
        self._projectsSetter = { p in projectManager.projects = p }
    }
}

extension ProjectManager {
    func eraseToAnyProjectManager() -> AnyProjectManager {
        return AnyProjectManager(self)
    }
}
