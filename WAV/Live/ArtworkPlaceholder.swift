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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaledToFit()
    }
}

struct Placeholder_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkPlaceholder()
    }
}
