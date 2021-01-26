//
//  ProjectThumbnail.swift
//  EffectScapades
//
//  Created by Lars Stegman on 12/01/2021.
//

import SwiftUI

struct ProjectThumbnail: View {
    var project: Project
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.random)
                    .aspectRatio(1.5, contentMode: .fit)
                    .cornerRadius(32)
                Text(project.name.first?.uppercased() ?? "")
                    .font(.largeTitle)
                    .bold()
            }
            Text(project.name)
                .font(.callout)
        }
    }
}

struct ProjectThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        ProjectThumbnail(project: .exampleProject())
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
