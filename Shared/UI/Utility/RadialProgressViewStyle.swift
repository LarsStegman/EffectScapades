//
//  RadialProgressView.swift
//  EffectScapades
//
//  Created by Lars Stegman on 03/01/2021.
//

import Foundation
import SwiftUI

struct RadialProgressViewStyle: ProgressViewStyle {
    var strokeWidth: CGFloat = 8.0
    var capStyle: CGLineCap = .square
    func makeBody(configuration: Configuration) -> some View {
        let start = Angle.radians(-0.5 * .pi)
        let progress = Angle.radians(2.0 * (configuration.fractionCompleted ?? 0.0) * .pi)
        return GeometryReader { geometry in
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0),
                            radius: min(geometry.size.width, geometry.size.height) / 2.0,
                            startAngle: start,
                            endAngle: start + progress,
                            clockwise: false,
                            transform: .identity)
            }
            .strokedPath(.init(lineWidth: strokeWidth, lineCap: capStyle))
        }
    }
}

struct RadialProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.34)
            .progressViewStyle(RadialProgressViewStyle())
            .foregroundColor(.red)
            .scaledToFit()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
