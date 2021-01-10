//
//  SoundSource.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import Foundation

enum FileError: Error {
    case notFound
}

enum SoundSource {
    case bundleFile(name: String)

    func url() throws -> URL {
        switch self {
        case .bundleFile(name: let filename):
            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else { throw FileError.notFound }
            return url
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
        }
    }

    enum CodingKeys: CodingKey {
        case type
        case name
    }
}
