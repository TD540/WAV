//
//  Artwork.swift
//  WAV
//
//  Created by Thomas on 18/11/2022.
//

import SwiftUI

struct Artwork: View {
    let image: Image
    @State var degrees = 0.0
    @State var shadowY = 5.0
    @State var shadowOpacity = 0.0
    @State var perspective = 0.5
    @ObservedObject var manager = MotionManager()
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .rotation3DEffect(.degrees(degrees), axis: (x: -0.5, y: 0, z: 0), perspective: perspective)
            .shadow(color: .black.opacity(shadowOpacity), radius: 10.0, x: 0.0, y: shadowY)
            .modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
            .onAppear {
                withAnimation() {
                    degrees = 5.0
                    shadowY = 15.0
                    shadowOpacity = 0.3
                    perspective = 0.7
                }
            }
    }
}

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        Artwork(image: Image("artwork-example"))
    }
}
