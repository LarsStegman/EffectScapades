//
//  TreeView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 09/01/2021.
//

import Foundation
import SwiftUI

struct TreeView<D: Identifiable,
                V: Identifiable,
                NodeView: View,
                LeafView: View>: View where D.ID == V.ID {
    struct ContentView: View {
        let data: [Tree<D, V>]

        @State private var isExpanded: [D.ID: Bool] = [:]
        let nodeView: (D) -> NodeView
        let leafView: (V) -> LeafView

        var body: some View {
            ForEach(data) { treeNode in
                switch treeNode {
                    case .node(let d, let children):
                        DisclosureGroup(isExpanded: Binding(get: {
                            isExpanded[d.id, default: false]
                        }, set: { expanded in
                            isExpanded[d.id] = expanded
                        })) {
                            ContentView(data: children, nodeView: nodeView, leafView: leafView)
                        } label: {
                            nodeView(d)
                        }

                    case .leaf(let v):
                        leafView(v)
                }
            }
        }
    }

    private let data: Tree<D, V>
    private let nodeView: (D) -> NodeView
    private let leafView: (V) -> LeafView

    init(_ data: Tree<D, V>,
         @ViewBuilder nodeView: @escaping (D) -> NodeView,
         @ViewBuilder leafView: @escaping (V) -> LeafView) {
        self.data = data
        self.nodeView = nodeView
        self.leafView = leafView
    }

    private var rootData: [Tree<D, V>] {
        switch data {
        case .node(_, let children):
            return children
        case .leaf(_):
            return [data]
        }
    }

    var body: some View {
        List {
            ContentView(data: rootData, nodeView: nodeView, leafView: leafView)
        }
    }
}


extension UUID: Identifiable {
    public var id: UUID {
        return self
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TreeView(
                .node(description: UUID(), children: [
                    .node(
                        description: UUID(),
                        children: [
                            .leaf(UUID()),
                            .node(
                                description: UUID(),
                                children: [
                                    .leaf(UUID()),
                                    .leaf(UUID()),
                                ]),
                        ]),
                    .leaf(UUID()),
                ])
            ) { description in
                Text("node: \(description)")
            } leafView: { id in
                Text("leaf: \(id)")
            }
        }
    }
}
