//
//  Globe.swift
//  WAV
//
//  Created by Thomas on 16/11/2022.
//

import SwiftUI

struct NoArtwork: View {
    var body: some View {
        Image("Globe")
            .resizable()
            .scaledToFit()
            .aspectRatio(1, contentMode: .fit)
    }
}

struct Globe_Previews: PreviewProvider {
    static var previews: some View {
        NoArtwork()
    }
}
