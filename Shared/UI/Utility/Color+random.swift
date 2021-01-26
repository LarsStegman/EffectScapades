//
//  Color+random.swift
//  EffectScapades
//
//  Created by Lars Stegman on 10/01/2021.
//

import Foundation
import SwiftUI

extension Color {
    static var random: Color {
        Color(.displayP3, red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1.0)
    }
}
