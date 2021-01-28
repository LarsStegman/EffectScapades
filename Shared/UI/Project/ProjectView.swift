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
                .navigationBarItems(leading: leadingButtons, trailing: trailingButtons)

            if let firstScene = sceneManager.scenes.first?.inorder().first {
                SceneView(scene: firstScene)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .environmentObject(sceneManager)
    }

    var leadingButtons: some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
        }) {
            Image(systemName: "rectangle.grid.2x2")
        }
    }

    var trailingButtons: some View {
        EditButton()
    }

}
