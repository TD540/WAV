//
//  Placeholder.swift
//  WAV
//
//  Created by Thomas on 16/11/2022.
//

import SwiftUI

struct ArtworkPlaceholder: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(5)
            .background(Rectangle().fill(Color.accentColor))
    }
}

struct Placeholder_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkPlaceholder()
    }
}
