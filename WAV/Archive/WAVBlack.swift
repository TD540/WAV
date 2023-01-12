//
//  WAVBlack.swift
//  WAV
//
//  Created by Thomas on 12/01/2023.
//

import SwiftUI

struct WAVBlackModifier: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(8)
            .foregroundColor(.white)
            .background(.black)
            .font(.custom("pixelmix", size: size))
            .lineSpacing(4)
    }
}
extension View {
    func wavBlack(size: CGFloat = 14) -> some View {
        self.modifier(WAVBlackModifier(size: size))
    }
}

struct WAVBlack_Previews: PreviewProvider {
    static var previews: some View {
        Text(".wavBlack(size: 20)")
            .wavBlack(size: 20)
    }
}
