//
//  CreateSceneNodeForm.swift
//  EffectScapades
//
//  Created by Lars Stegman on 24/01/2021.
//

import SwiftUI

struct CreateSceneNodeForm: View {
    private enum NodeType {
        case folder
        case scene
    }
    @EnvironmentObject var sceneManager: AnySceneManager
    @Environment(\.presentationMode) var presentationMode

    @State private var type: NodeType = .scene
    @State var folder: SceneFolderDescription? = nil
    @State var name: String = ""
    @State var description: String = ""

    var body: some View {
        Form {
            Picker(selection: $type.animation(), label: Text("Picker")) {
                Text("Folder").tag(NodeType.folder)
                Text("Scene").tag(NodeType.scene)
            }
            .pickerStyle(SegmentedPickerStyle())
            NavigationLink(destination: SceneFolderSelectionView(folder: $folder)) {
                HStack {
                    Image(systemName: "folder")
                    Text(folder?.name ?? "Folder")
                }
            }
            TextField("Name", text: $name)
            if (type == .scene) {
                TextField("Description", text: $description)
                    .lineLimit(0)
                    .transition(.slide)
            }
        }
        .navigationBarTitle(type == .folder ? "New folder" : "New scene", displayMode: .inline)
        .navigationBarItems(trailing: createButton)
    }

    var createButton: some View {
        Button(action: {
            if type == .scene {
                let scene = EffectScene(name: name,
                                        description: description,
                                        effects: [],
                                        settings: [:])
                sceneManager.scenes.insert(scene, in: folder)
            } else if type == .folder {
                let newFolder = SceneFolderDescription(name:  name)
                sceneManager.scenes.insert(newFolder, in: folder)
            }

            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Create")
        }
        .disabled(name.count < 1)
    }
}

struct CreateSceneNodeForm_Previews: PreviewProvider {
    static var previews: some View {
        CreateSceneNodeForm()
    }
}
