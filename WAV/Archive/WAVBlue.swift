//
//  WAVBlue.swift
//  WAV
//
//  Created by Thomas on 12/01/2023.
//

import SwiftUI

struct WAVBlueModifier: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(8)
            .foregroundColor(.white)
            .background(Color("WAVBlue"))
            .font(.custom("pixelmix", size: size))
            .lineSpacing(4)
    }
}
extension View {
    func wavBlue(size: CGFloat = 14) -> some View {
        self.modifier(WAVBlueModifier(size: size))
    }
}

struct WAVBlue_Previews: PreviewProvider {
    static var previews: some View {
        Text(".wavBlue(size: 20)")
            .wavBlue(size: 20)
    }
}
