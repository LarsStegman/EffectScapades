//
//  Color+lighten-darken.swift
//  EffectScapades
//
//  Created by Lars Stegman on 04/01/2021.
//

import Foundation
import SwiftUI

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        return (r, g, b, o)
    }

    func lighter(by percentage: CGFloat = 0.3) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 0.3) -> Color {
        return self.adjust(by: -1.0 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 0.3) -> Color {
        return Color(red: min(Double(self.components.red + percentage), 1.0),
                     green: min(Double(self.components.green + percentage), 1.0),
                     blue: min(Double(self.components.blue + percentage), 1.0),
                     opacity: Double(self.components.opacity))
    }
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                HStack(spacing: 0) {
                    ForEach(0..<11) { f in
                        ZStack {
                            Color.red.lighter(by: CGFloat(Double(f) / 10.0))
                                .frame(width: 50, height: 50)
                            Text("\(Double(f) / 10.0)")
                        }
                    }
                }
                HStack(spacing: 0) {
                    ForEach(0..<11) { f in
                        ZStack {
                            Color.blue.darker(by: CGFloat(Double(f) / 10.0))
                                .frame(width: 50, height: 50)
                            Text("\(Double(f) / 10.0)")
                                .foregroundColor(.white)
                        }
                    }
                }
        }
        }
        .previewLayout(.sizeThatFits)
    }
}
