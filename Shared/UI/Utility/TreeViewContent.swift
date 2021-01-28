//
//  TreeView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 09/01/2021.
//

import Foundation
import SwiftUI

/// A view that can display tree data.
struct TreeViewContent<D: Identifiable,
                       V: Identifiable,
                       NodeView: View,
                       LeafView: View>: DynamicViewContent where D.ID == V.ID {
    @State private var isExpanded: [D.ID: Bool] = [:]
    let data: [Tree<D, V>]
    private let defaultExpanded: Bool
    private let nodeView: (D) -> NodeView
    private let leafView: (V) -> LeafView

    init(_ data: [Tree<D, V>],
         defaultExpanded: Bool = false,
         @ViewBuilder nodeView: @escaping (D) -> NodeView,
         @ViewBuilder leafView: @escaping (V) -> LeafView) {
        self.data = data
        self.defaultExpanded = defaultExpanded
        self.nodeView = nodeView
        self.leafView = leafView
    }

    init(_ data: Tree<D, V>,
         defaultExpanded: Bool = false,
         @ViewBuilder nodeView: @escaping (D) -> NodeView,
         @ViewBuilder leafView: @escaping (V) -> LeafView) {
        self.init([data], defaultExpanded: defaultExpanded, nodeView: nodeView, leafView: leafView)
    }

    var body: some View {
        ForEach(data) { treeNode in
            switch treeNode {
            case .node(let d, let children):
                DisclosureGroup(isExpanded: Binding(get: {
                    isExpanded[d.id, default: self.defaultExpanded]
                }, set: { expanded in
                    isExpanded[d.id] = expanded
                })) {
                    TreeViewContent(children, defaultExpanded: defaultExpanded,
                                    nodeView: nodeView, leafView: leafView)
                } label: {
                    nodeView(d)
                }

            case .leaf(let v):
                leafView(v)
            }
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
            List {
                TreeViewContent(
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
}
