//
//  Artwork.swift
//  WAV
//
//  Created by Thomas on 18/11/2022.
//

import SwiftUI

struct Artwork: View {
    let image: Image
    @State var imageDegrees = 0.0
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .rotation3DEffect(.degrees(imageDegrees), axis: (x: -0.5, y: 0, z: 0), perspective: 0.5)
            .onAppear {
                withAnimation() {
                    imageDegrees = 5.0
                }
            }
    }
}

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        Artwork(image: Image("artwork-example"))
    }
}
