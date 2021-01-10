//
//  Color+Codable.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import Foundation
import SwiftUI

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let colorData = try container.decode(Data.self)
        let uiColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? UIColor.black
        self = Color(uiColor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        let convertedColor = UIColor(self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: convertedColor, requiringSecureCoding: false)
        try container.encode(colorData)
    }
}
