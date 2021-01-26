//
//  SoundSource.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import Foundation
import MediaPlayer

enum FileError: Error {
    case notFound
}

enum SoundSource {
    case bundleFile(name: String)
    case mpMediaItem(persistentId: MPMediaEntityPersistentID)

    func url() throws -> URL {
        switch self {
        case .bundleFile(name: let filename):
            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else { throw FileError.notFound }
            return url
        case .mpMediaItem(persistentId: let id):
            let predicate = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            if let url = query.items?.first?.assetURL {
                return url
            } else {
                throw FileError.notFound
            }
        }
    }
}

extension SoundSource: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "bundleFile":
            self = .bundleFile(name: try container.decode(String.self, forKey: .name))
        case "mpMediaItem":
            self = .mpMediaItem(persistentId: try container.decode(MPMediaEntityPersistentID.self, forKey: .name))
        default:
            throw DecodingError.typeMismatch(SoundSource.self,
                                             DecodingError.Context(codingPath: decoder.codingPath,
                                                                   debugDescription: "SoundSource unknown type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .bundleFile(name: let name):
            try container.encode("bundleFile", forKey: .type)
            try container.encode(name, forKey: .name)
        case .mpMediaItem(persistentId: let id):
            try container.encode("mpMediaItem", forKey: .type)
            try container.encode(id, forKey: .name)
        }
    }

    enum CodingKeys: CodingKey {
        case type
        case name
    }
}

extension SoundSource: Equatable {
    static func ==(lhs: SoundSource, rhs: SoundSource) -> Bool {
        switch (lhs, rhs) {
        case (.bundleFile(let lhsF), .bundleFile(let rhsF)): return lhsF == rhsF
        case (.mpMediaItem(let lhsId), .mpMediaItem(let rhsId)): return lhsId == rhsId
        default: return false
        }
    }
}
