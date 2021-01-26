//
//  ProjectSelectionView.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 10/01/2021.
//

import SwiftUI

struct ProjectOverviewView: View {
    @EnvironmentObject var projectsManager: AnyProjectManager
    @State private var activeProject: Project? = nil

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init(.adaptive(minimum: 150, maximum: 200))]) {
                ForEach(Array(projectsManager.projects.values)) { project in
                    Button(action: {
                        self.activeProject = project
                    }) {
                        ProjectThumbnail(project: project)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .fullScreenCover(item: $activeProject) {
            ProjectView($0)
        }
    }
}

struct ProjectSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectOverviewView()
            .environmentObject(LiteralProjectManager(projects: [
                .exampleProject(),
                .exampleProject()
            ]).eraseToAnyProjectManager())
    }
}
