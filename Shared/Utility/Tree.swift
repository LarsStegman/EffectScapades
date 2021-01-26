//
//  Tree.swift
//  EffectScapades
//
//  Created by Lars Stegman on 07/01/2021.
//

import Foundation

enum Tree<D, V> {
    case node(description: D, children: [Self])
    case leaf(_ value: V)
}


extension Tree {
    private func inorder(array: inout [V]) {
        switch self {
        case .node(description: _, children: let children): children.forEach({ c in c.inorder(array: &array) })
        case .leaf(value: let v): array.append(v)
        }
    }

    func inorder() -> [V] {
        var a = [V]()
        self.inorder(array: &a)
        return a
    }
}

extension Tree: Codable where D: Codable, V: Codable {
    private enum CodingKeys: CodingKey {
        case node
        case leaf

        enum Node: CodingKey {
            case description
            case children
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.node) {
            let nodeContainer = try decoder.container(keyedBy: CodingKeys.Node.self)
            self = .node(description: try nodeContainer.decode(D.self, forKey: .description),
                         children: try nodeContainer.decode([Tree<D, V>].self, forKey: .children))
        } else if container.contains(.leaf) {
            self = .leaf(try container.decode(V.self, forKey: .leaf))
        } else {
            throw DecodingError.keyNotFound(CodingKeys.node,
                                            DecodingError.Context(codingPath: decoder.codingPath,
                                                                  debugDescription: "Case missing") )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .node(description: let description, children: let children):
            var nodeContainer = container.nestedContainer(keyedBy: CodingKeys.Node.self, forKey: .node)
            try nodeContainer.encode(description, forKey: .description)
            try nodeContainer.encode(children, forKey: .children)
        case .leaf(value: let v):
            try container.encode(v, forKey: .leaf)
        }
    }
}

extension Tree where V: Identifiable {
    func find(_ identifier: V.ID) -> V? {
        switch self {
        case .node(_, let children):
            for c in children {
                let v = c.find(identifier)
                if v != nil {
                    return v
                }
            }

            return nil

        case .leaf(let v):
            if v.id == identifier {
                return v
            } else {
                return nil
            }
        }
    }
}

extension Tree {
    var children: [Self]? {
        if case let .node(_, children) = self {
            return children
        } else {
            return nil
        }
    }
}


extension Tree: Identifiable where D: Identifiable, V: Identifiable, D.ID == V.ID {
    var id: D.ID {
        switch self {
        case .leaf(let v):
            return v.id
        case .node(let d, children: _):
            return d.id
        }
    }
}

extension Tree: Equatable where D: Equatable, V: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.leaf(let lhsV), .leaf(let rhsV)):
            return lhsV == rhsV
        case (.node(let lhsD, let lhsC), .node(let rhsD, let rhsC)):
            return lhsD == rhsD && lhsC == rhsC
        default:
            return false
        }
    }
}

extension Tree: Hashable where D: Hashable, V: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .leaf(let v):
            hasher.combine(v)
        case .node(description: let d, children: let c):
            hasher.combine(d)
            c.forEach { t in
                hasher.combine(t)
            }
        }
    }
}

extension Tree where D: Identifiable {
    mutating func insert(_ v: Self, at: D.ID) {
        switch self {
        case .node(description: let d, children: let children) where d.id == at:
            self = .node(description: d, children: children + [v])
        case .node(description: let d, children: var children):
            children = children.map { c in
                var c = c
                c.insert(v, at: at)
                return c
            }
            self = .node(description: d, children: children)
        case .leaf(_):
            return
        }
    }
}
