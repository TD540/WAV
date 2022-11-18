//
//  Globe.swift
//  WAV
//
//  Created by Thomas on 16/11/2022.
//

import SwiftUI

struct NoArtwork: View {
    var body: some View {
        Image("NoArtwork")
            .resizable()
            .scaledToFit()
            .aspectRatio(1, contentMode: .fit)
            .border(.black)
    }
}

struct NoArtwork_Previews: PreviewProvider {
    static var previews: some View {
        NoArtwork()
    }
}
