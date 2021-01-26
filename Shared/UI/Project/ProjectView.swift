//
//  ProjectView.swift
//  EffectScapades (iOS)
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation
import SwiftUI

struct ProjectView: View {
    @State var project: Project
    @ObservedObject var sceneManager: AnySceneManager
    @Environment(\.presentationMode) var presentation

    init(_ project: Project) {
        self._project = State(initialValue: project)
        self.sceneManager = StoredSceneManager(project: project).eraseToAnySceneManager()
    }

    var body: some View {
        NavigationView {
            SceneSelectionView()
                .navigationTitle(project.name)
                .navigationBarItems(leading: Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Image(systemName: "rectangle.grid.2x2")
                }, trailing: NavigationLink(destination: CreateSceneNodeForm()) {
                    Image(systemName: "plus")
                }
                .isDetailLink(false))
            if let firstScene = sceneManager.scenes.first?.inorder().first {
                SceneView(scene: firstScene)
            }
        }
        .environmentObject(sceneManager)
    }
}
